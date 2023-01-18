import numpy as np
import random
import math
from typing import Union, List, Tuple


def read_city_file(nom_fichier: str) -> Tuple[int, List[Tuple[int, float, float]]]:
    with open(nom_fichier, "r") as f:
        n = int(f.readline())
        villes = []
        for ligne in f:
            id_ville, x, y = ligne.split()
            villes.append((int(id_ville), float(x), float(y)))
    return n, villes


def solution_initiale_au_hasard(n: int) -> List[int]:
    villes = list(range(1, n + 1))
    solution = []
    for i in range(n):
        indice_ville = random.randint(0, len(villes) - 1)
        solution.append(villes.pop(indice_ville))
    return solution


def calculer_valeur_solution(solution: List[int], villes: List[Tuple[int, float, float]]) -> float:
    distance_totale = 0
    distance_totale += math.sqrt((villes[solution[0] - 1][1])
                                 ** 2 + (villes[solution[0] - 1][2])**2)
    for i in range(len(solution) - 1):
        ville1 = villes[solution[i] - 1]
        ville2 = villes[solution[i + 1] - 1]
        distance_totale += math.sqrt((ville1[1] - ville2[1])
                                     ** 2 + (ville1[2] - ville2[2])**2)
    distance_totale += math.sqrt((villes[solution[-1] - 1][1])
                                 ** 2 + (villes[solution[-1] - 1][2])**2)
    return distance_totale


def meilleur_voisin(solution: List[int], villes: List[Tuple[int, float, float]]) -> List[int]:
    meilleure_solution = solution[:]
    distance_minimale = calculer_valeur_solution(solution, villes)
    for i in range(len(solution)):
        for j in range(i + 1, len(solution)):
            solution[i], solution[j] = solution[j], solution[i]
            distance_solution = calculer_valeur_solution(solution, villes)
            if distance_solution < distance_minimale:
                meilleure_solution = solution[:]
                distance_minimale = distance_solution
            solution[i], solution[j] = solution[j], solution[i]
    return meilleure_solution


def city_steepest_hill_climbing(villes: List[Tuple[int, float, float]], x: List[int], max_depl: int) -> Union[List[int], int]:
    s_courant = x[:]
    distance_minimale = calculer_valeur_solution(s_courant, villes)
    nb_depl = 0
    stop = False
    while nb_depl < max_depl and not stop:
        s_voisin = meilleur_voisin(s_courant, villes)
        distance_voisin = calculer_valeur_solution(s_voisin, villes)
        if distance_voisin < distance_minimale:
            s_courant = s_voisin[:]
            distance_minimale = distance_voisin
        else:
            stop = True
        nb_depl += 1
    return s_courant, distance_minimale


def random_restart_city_hill_climbing(villes: List[Tuple[int, float, float]], x: List[int], max_depl: int, max_restart: int) -> Union[List[int], int]:
    s_best = x[:]
    distance_minimale = calculer_valeur_solution(s_best, villes)
    nb_restart = 0
    while nb_restart < max_restart:
        s_prime, distance_prime = city_steepest_hill_climbing(
            villes, solution_initiale_au_hasard(len(villes)), max_depl)
        if distance_prime < distance_minimale:
            s_best = s_prime[:]
            distance_minimale = distance_prime
        nb_restart += 1
    return s_best, distance_minimale


def tabou_search(villes: List[Tuple[int, float, float]], x: List[int], max_depl: int, tabou_size: int) -> Union[List[int], int]:
    s_courant = x[:]
    distance_minimale = calculer_valeur_solution(s_courant, villes)
    tabou = []
    nb_depl = 0
    stop = False
    while nb_depl < max_depl and not stop:
        meilleurs_voisins = []
        distance_minimale_voisins = float("inf")
        for i in range(len(s_courant)):
            for j in range(i + 1, len(s_courant)):
                s_voisin = s_courant[:]
                s_voisin[i], s_voisin[j] = s_voisin[j], s_voisin[i]
                distance_voisin = calculer_valeur_solution(s_voisin, villes)
                if distance_voisin < distance_minimale_voisins and s_voisin not in tabou:
                    meilleurs_voisins = [s_voisin]
                    distance_minimale_voisins = distance_voisin
                elif distance_voisin == distance_minimale_voisins and s_voisin not in tabou:
                    meilleurs_voisins.append(s_voisin)
        if meilleurs_voisins:
            s_courant = meilleurs_voisins[np.random.randint(
                0, len(meilleurs_voisins))]
            distance_minimale = distance_minimale_voisins
            tabou.append(s_courant)
            if len(tabou) > tabou_size:
                tabou.pop(0)
        else:
            stop = True
        nb_depl += 1
    return s_courant, distance_minimale


tsp5 = read_city_file("files/tsp5.txt")
tsp101 = read_city_file("files/tsp101.txt")

print(' Valeur pour la solution [5, 3, 4, 1, 2] :')
print(calculer_valeur_solution([5, 3, 4, 1, 2], tsp5[1]), 'km')

print('')
print('Résultat de la méthode steepest hill climbing sur le fichier tsp5 :')
solution, distance = random_restart_city_hill_climbing(tsp5[1],
                                                       solution_initiale_au_hasard(5), 100, 100)
print(solution, distance, 'km')

print('')
print('Résultat de la méthode steepest hill climbing sur le fichier tsp101 :')
solution, distance = random_restart_city_hill_climbing(tsp101[1],
                                                       solution_initiale_au_hasard(101), 100, 100)

print(solution, distance, 'km')

print('')
print("Solution tsp5 :")
for tabou_size in [5, 10, 20, 50, 100]:
    print(f"    Avec une liste tabou de taille {tabou_size} :")
    for max_depl in [100, 1000, 10000, 100000]:
        solution, distance = tabou_search(
            tsp5[1], solution_initiale_au_hasard(5), max_depl, tabou_size)
        print(
            f"      Avec un nombre maximal de déplacements {max_depl}: ")
        print(f"        {solution}(distance={distance: .2f})")

print('')
print("Solution tsp101 :")
for tabou_size in [5, 10, 20, 50, 100]:
    print(f"    Avec une liste tabou de taille {tabou_size} :")
    for max_depl in [100, 1000, 10000, 100000]:
        solution, distance = tabou_search(
            tsp101[1], solution_initiale_au_hasard(101), max_depl, tabou_size)
        print(
            f"      Avec un nombre maximal de déplacements {max_depl}: ")
        print(f"        {solution}(distance={distance: .2f})")
