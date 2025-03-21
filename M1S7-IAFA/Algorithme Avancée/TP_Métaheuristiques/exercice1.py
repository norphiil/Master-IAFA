import numpy as np
import random
from typing import Tuple

random.seed(10)


def readFile(filename: str) -> np.array:
    size: int = 6
    with open(filename, 'r') as f:
        data = [int(x) for x in f.read().split()]
        size = int(data[0])
        p = int(data[1])
        data = data[2:]
        matrix = [data[i:i + size] for i in range(0, len(data), size)]
        return np.array(matrix), p


def new_random_x(size: int) -> list:
    x = []
    for _ in range(size):
        x.append(random.randint(0, 1))
    return x


def ubqp(q: np.array, x: list) -> int:
    return sum(
        q[i][j] * x[i] * x[j] for i in range(len(x)) for j in range(len(x))
    )


def best_neighbor(q: np.array, x: list) -> list:
    best = [x]
    best_score = ubqp(q, x)
    for i in range(len(x)):
        x_prime = x.copy()
        x_prime[i] = 1 - x_prime[i]
        score = ubqp(q, x_prime)
        if score < best_score:
            best = [x_prime]
            best_score = score
        elif score == best_score:
            best.append(x_prime)
    return best[np.random.randint(0, len(best))]


def steepest_hill_climbing(q: np.array, x: list, max_depl: int) -> Tuple[list, int]:
    s_best = x
    s_score_best = ubqp(q, s_best)
    nb_depl = 0
    stop = False
    while nb_depl < max_depl and not stop:
        s_prime = best_neighbor(q, s_best)
        s_prime_score = ubqp(q, s_prime)
        if s_prime_score < s_score_best:
            s_best = s_prime
            s_score_best = s_prime_score
        else:
            stop = True
        nb_depl += 1
    return s_prime, s_prime_score


def random_restart_hill_climbing(q: np.array, x: list, max_depl: int, max_restart: int) -> Tuple[list, int]:
    s_best = x
    s_score_best = ubqp(q, s_best)
    nb_restart = 0
    while nb_restart < max_restart:
        s_prime, s_prime_score = steepest_hill_climbing(
            q, new_random_x(len(q)), max_depl)
        if s_prime_score < s_score_best:
            s_best = s_prime
            s_score_best = s_prime_score
        nb_restart += 1
    return s_best, s_score_best


def tabu_search(q: np.array, x: list, max_depl: int, max_tabu: int) -> list:
    s = x
    tabu = []
    nb_depl = 0
    msol = s
    stop = False
    while nb_depl < max_depl and not stop:
        if len(tabu) > max_tabu:
            tabu.pop(0)
        neighbors = [s_prime for s_prime in [
            best_neighbor(q, s)] if s_prime not in tabu]
        if len(neighbors) > 0:
            s_prime = neighbors[0]
            tabu.append(s)
            if ubqp(q, s_prime) < ubqp(q, msol):
                msol = s_prime
            s = s_prime
        else:
            stop = True
        nb_depl += 1
    return msol, ubqp(q, msol)


def best_neighbor_bis(q: np.array, x: list, p: int) -> list:
    best = [x]
    best_score = ubqp(q, x)
    for i in range(len(x)):
        x_prime = x.copy()
        x_prime[i] = 1 - x_prime[i]
        if sum(x_prime) < p:  # vérifie si la contrainte est respectée
            continue
        score = ubqp(q, x_prime)
        if score < best_score:
            best = [x_prime]
            best_score = score
        elif score == best_score:
            best.append(x_prime)
    return best[np.random.randint(0, len(best))]


def steepest_hill_climbing_bis(q: np.array, x: list, p: int, max_depl: int) -> Tuple[list, int]:
    s_best = x
    s_score_best = ubqp(q, s_best)
    nb_depl = 0
    stop = False
    while nb_depl < max_depl and not stop:
        s_prime = best_neighbor_bis(q, s_best, p)
        s_prime_score = ubqp(q, s_prime)
        if s_prime_score < s_score_best:
            s_best = s_prime
            s_score_best = s_prime_score
        else:
            stop = True
        nb_depl += 1
    return s_prime, s_prime_score


def random_restart_hill_climbing_bis(q: np.array, x: list, p: int, max_depl: int, max_restart: int) -> Tuple[list, int]:
    s_best = x
    s_score_best = ubqp(q, s_best)
    nb_restart = 0
    while nb_restart < max_restart:
        s_prime, s_prime_score = steepest_hill_climbing_bis(
            q, new_random_x(len(q)), p, max_depl)
        if s_prime_score < s_score_best:
            s_best = s_prime
            s_score_best = s_prime_score
        nb_restart += 1
    return s_best, s_score_best


print('Execution des différents algorithmes sur le fichier partition6 :')
Qpartition6, Ppartition6 = readFile('files/partition6.txt')

X = new_random_x(len(Qpartition6))

print(best_neighbor(Qpartition6, X))
print(steepest_hill_climbing(Qpartition6, X, 100))
print(random_restart_hill_climbing(Qpartition6, X, 100, 100))

print('')
print('Execution des différents algorithmes sur le fichier graphe12345 :')
Qgraphe12345, Pgraphe12345 = readFile('files/graphe12345.txt')

X = new_random_x(len(Qgraphe12345))

print(best_neighbor(Qgraphe12345, X))
print(steepest_hill_climbing(Qgraphe12345, X, 100))
print(random_restart_hill_climbing(Qgraphe12345, X, 100, 100))


print('Execution de l\'algorithme tabu search sur le fichier partition6 :')
X = new_random_x(len(Qpartition6))
print('List tabou taille 1 :')
print(tabu_search(Qpartition6, X, 100, 1))
print('List tabou taille 10 :')
print(tabu_search(Qpartition6, X, 100, 10))
print('List tabou taille 100 :')
print(tabu_search(Qpartition6, X, 100, 100))
print('List tabou taille 1000 :')
print(tabu_search(Qpartition6, X, 100, 1000))
print('List tabou taille 10000 :')
print(tabu_search(Qpartition6, X, 100, 10000))

print('')
print('Execution de l\'algorithme tabu search sur le fichier graphe12345 :')
X = new_random_x(len(Qgraphe12345))
print('List tabou taille 1 :')
print(tabu_search(Qgraphe12345, X, 100, 1))
print('List tabou taille 10 :')
print(tabu_search(Qgraphe12345, X, 100, 10))
print('List tabou taille 100 :')
print(tabu_search(Qgraphe12345, X, 100, 100))
print('List tabou taille 1000 :')
print(tabu_search(Qgraphe12345, X, 100, 1000))
print('List tabou taille 10000 :')
print(tabu_search(Qgraphe12345, X, 100, 10000))


print('Execution de l\'algorithme random restart hill climbing sur le fichier partition6 :')
X = new_random_x(len(Qpartition6))
print(random_restart_hill_climbing_bis(Qpartition6, X, Ppartition6, 100, 100))

print('')
print('Execution de l\'algorithme random restart hill climbing sur le fichier graphe12345 :')
X = new_random_x(len(Qgraphe12345))
print(random_restart_hill_climbing_bis(
    Qgraphe12345, X, Pgraphe12345, 100, 100))
