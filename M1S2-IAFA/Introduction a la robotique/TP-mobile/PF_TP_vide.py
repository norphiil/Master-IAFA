#!/usr/bin/env python

import sys
import rospy
import numpy as np
from nav_msgs.msg import Odometry
from geometry_msgs.msg import Twist, Quaternion, Point, Vector3
from std_msgs.msg import Empty, Int16
import time
import signal
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
import random
import math

class PF_TP():
	def __init__(self):
		# rospy.init_node('PF_TP', anonymous=True)
		self.shutdown = False
		
		# Topics
		self.odom_topic = '/odom'
		self.vel_cmd_topic = '/cmd_vel'

		# For ROS with turtlebot3
		rospy.Subscriber(self.odom_topic, Odometry, self.odom_callback)
		self.vel_publisher = rospy.Publisher(self.vel_cmd_topic, Twist, queue_size=1)

		### Parameters ###
		self.nb_obstacles = 10	# 10 obstacles
		self.W_length = 6;		# Room 10m x 10m
		self.dW = 0.05; 			# Resolution 20cm
		self.U_max = 1e2;		# Max potential	
		self.eps_goal = 0.01;	# Stopping criteria	
		self.V_max = 0.3;		# Max speed
		self.max_iters = 1000;	# Max iterations
		self.iters = 0
		self.K_att = 10
		self.K_rep = 0.2
		self.d0 = 10

		### Utils definition ###
		x = y = np.arange(-self.W_length/2, self.W_length/2 +self.dW, self.dW)
		self.X, self.Y = np.meshgrid(x,y)
		
		self.pos_init = np.array([-2, -0.5])
		self.pos_goal = np.array([2, 0.5])

		self.pos_obst = self.create_randomMap()
		# self.pos_obst = self.create_gazeboMap()
		# self.pos_obst = np.load("map_puits.npy")

		# State
		self.pose = self.pos_init
		self.yaw = 0

		# Command
		self.v = np.zeros(2,)
		self.q_dot = np.zeros(2,)

		# Potential Field and Gradient
		self.U_att = self.U_att()
		self.U_rep = self.U_rep()
		self.U_tot = self.U_tot(self.U_att, self.U_rep)
		self.gradUx, self.gradUy = self.compute_grad(self.U_tot)

		# Trace
		self.traj = np.zeros((0,3))

		# Plot
		self.plot_map()
		self.plot_U(self.U_tot)


	### Methods ###
	def odom_callback(self, odom):
		# Update robot state 
		self.pose = np.array([odom.pose.pose.position.x, odom.pose.pose.position.y])
		self.yaw = self.quat2yaw(odom.pose.pose.orientation)

	def quat2yaw(self, orientation): 
		# Convert quaternion into position + yaw
		z = orientation.z
		w = orientation.w
		return np.arctan2(2 * (w * z), w * w - z * z)

	def U_att_parabolique(self, metric):
		value = 1.0/2 * self.K_att * (np.linalg.norm(metric - self.pos_goal) ** 2)
		return 0 if value < 0 else value
	def U_att_conique(self, metric):
		value = self.K_att * np.linalg.norm(metric - self.pos_goal)
		return 0 if value < 0 else value

	### Potential fields definition
	def U_att(self):
		### Compute an U_att ###
		U_att = np.zeros_like(self.X)

		metric_x = 0
		metric_y = 0
		for x, U_x in enumerate(U_att):
			for y, att in enumerate(U_x):
				metric_x = - self.W_length / 2 + x * self.dW
				metric_y = - self.W_length / 2 + y * self.dW
				U_att[x, y] = self.U_att_conique([metric_x, metric_y])
		return U_att

	def U_rep_exponentielle(self, metric):
		value = 0.0
		for obst in self.pos_obst:
			value += self.U_max * math.exp(-np.linalg.norm(metric - obst) / self.K_rep)
		return 0 if value < 0 else value

	def U_rep_hyperbolique(self, metric):
		value = 0.0
		for obst in self.pos_obst:
			d = np.linalg.norm(metric - obst)
			if d < self.d0:
				if d == 0:
					value += self.U_max
				else:
					tmp_value = 1.0/2 * self.K_rep * (((1/d)  - (1/self.d0)) ** 2)
					if tmp_value > self.U_max:
						value += self.U_max
					else:
						value += tmp_value
			else:
				value += 0.0
		return 0 if value < 0 else value

	def U_rep(self):
		### Compute U_rep ###
		U_rep = np.zeros_like(self.X)

		metric_x = 0
		metric_y = 0
		for x, U_x in enumerate(U_rep):
			for y, rep in enumerate(U_x):
				metric_x = - self.W_length / 2 + x * self.dW
				metric_y = - self.W_length / 2 + y * self.dW
				U_rep[x, y] = self.U_rep_exponentielle([metric_x, metric_y])
		return U_rep

	def U_tot(self, U_att, U_rep):
		return U_att + U_rep

	def compute_grad(self, U):
		gradUx, gradUy = np.gradient(U, self.dW, axis=0), np.gradient(U, self.dW, axis=1)
		return gradUx, gradUy

	### Velocity command ###
	def compute_speed(self, v):
		# Convert holomomic command into differential drive one
		Epose = np.linalg.norm(v)

		v_robot = np.array([np.cos(self.yaw), np.sin(self.yaw)])
		Eyaw = - np.sign(np.cross(v_robot, v)) * np.arccos(np.dot(v_robot, v) / (np.linalg.norm(v_robot) * np.linalg.norm(v)))

		Kpose = 1 * (np.pi - abs(Eyaw)) / np.pi
		Kyaw = 0.5
		q_dot = np.array([Kpose * Epose, Kyaw * Eyaw])
		return q_dot

	def vel_cmd(self, q_dot):
		# Publish command on robot topic
		vel_msg = Twist()
		vel_msg.linear.x = q_dot[0]
		vel_msg.angular.z = q_dot[1]
		self.vel_publisher.publish(vel_msg)

	### Plotters ###
	def plot_map(self):
		fig_map, ax_map = plt.subplots(figsize=(10, 10))
		# Plot map
		ax_map.scatter(*self.pos_init.T, marker = (3, 0, self.yaw * 180/np.pi + 270), color = 'b', s = 100)
		ax_map.scatter(*self.pos_goal.T, marker = 'o', color = 'g', s = 100)
		# self.pos_obst = np.load("map.npy")
		for obst in self.pos_obst:
			ax_map.scatter(obst[0], obst[1], marker = 'o', color = 'r', s = 100)
		ax_map.set_xlim((-self.W_length/2 -self.dW, self.W_length/2 +self.dW))
		ax_map.set_ylim((-self.W_length/2 -self.dW, self.W_length/2 +self.dW))
		minor_locator = MultipleLocator(base = self.dW)
		ax_map.xaxis.set_minor_locator(minor_locator)
		ax_map.yaxis.set_minor_locator(minor_locator)
		ax_map.grid(which = 'minor')

	def plot_U(self, U, plot_traj=False):
		fig_U = plt.figure(figsize=(15, 12), tight_layout=True)
		ax_U = fig_U.add_subplot(111, projection = '3d')
		ax_U.set_xlabel('X')
		ax_U.set_ylabel('Y')
		ax_U.set_zlabel('U')
		ax_U.plot_surface(self.X, self.Y, U.T, cmap = cm.coolwarm, rstride = 1, cstride = 1)

		if plot_traj:
			ax_U.plot3D(*self.traj.T, c = 'k', linewidth = 2)

	### Maps creation ###
	def create_randomMap(self):
		pos_obst = []
		for i in range(self.nb_obstacles):
			x_obst = random.randint(-int(self.W_length / (2*self.dW)), int(self.W_length / (2*self.dW)) -1)
			y_obst = random.randint(-int(self.W_length / (2*self.dW)), int(self.W_length / (2*self.dW)) -1)
			pos_obst.append(np.array([x_obst * self.dW, y_obst * self.dW]))
		np.save("map", pos_obst)
		return pos_obst

	def create_gazeboMap(self):
		# Add obstacles
		pos_obst = []
		return pos_obst

	### Controllers ###
	def PF_control_holonom(self):
		Te = 0.01 # Sampling period
		x_next = self.pose[0]
		y_next = self.pose[1]
		pose_x = int((self.pose[0] + self.W_length / 2) / self.dW)
		pose_y = int((self.pose[1] + self.W_length / 2) / self.dW)
		self.traj = np.array([[x_next, y_next, self.U_tot[pose_x][pose_y]]])
		while self.conditionWhile():
			# Locate
			pose_x = int((self.pose[0] + self.W_length / 2) / self.dW)
			pose_y = int((self.pose[1] + self.W_length / 2) / self.dW)
			self.traj = np.concatenate((self.traj, np.array([[x_next, y_next, self.U_tot[pose_x][pose_y]]])))
			# Get ideal speed
			v = [-self.gradUx[pose_x][pose_y], -self.gradUy[pose_x][pose_y]]
			# Simulate command
			x_next = self.pose[0] + v[0] * Te
			y_next = self.pose[1] + v[1] * Te

			self.pose = [x_next, y_next]

			self.iters += 1

		self.plot_U(self.U_tot, True)
		plt.show()

	def PF_control_turtlebot(self):
		r = rospy.Rate(10)

		while self.conditionWhile():
			# Locate

			# Get ideal speed

			# Compute non-holomic speed
			self.q_dot = self.compute_speed(v)

			# Publish command
			self.vel_cmd(self.q_dot)
			self.iters += 1
			r.sleep()

		self.plot_U(self.U_tot, True)
		plt.show()

	### Shutdown ###
	def conditionWhile(self):
		cond = True
		if np.linalg.norm(self.pose - self.pos_goal) < self.eps_goal:
			print("Goal reached !")
			cond = False
		if self.iters > self.max_iters:
			print("Max iters reached !")
			cond = False
		if self.shutdown == True:
			print("Stopped by usr !")
			cond = False
		# if cond == False:
		# 	self.q_dot = np.zeros(2,)
		# 	self.vel_cmd(self.q_dot)
		return cond

	def keyboardInterruptHandler(self,signal,frame):
		self.shutdown = True

if __name__ == '__main__':
	PF_controller = PF_TP()
	signal.signal(signal.SIGINT, PF_controller.keyboardInterruptHandler)
	PF_controller.PF_control_holonom()
	#PF_controller.PF_control_turtlebot()
	plt.show()
