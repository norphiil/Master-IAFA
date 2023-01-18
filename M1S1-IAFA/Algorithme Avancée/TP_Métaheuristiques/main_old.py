import numpy as np
import random

random.seed(10)


def new_random_x(size: int) -> list:
    x = []
    for _ in range(size):
        x.append(random.randint(0, 1))
    return x


# Qgraphe12345 = [
#     [-17, 10, 10, 10, 0, 20],
#     [10, -18, 10, 10, 10, 20],
#     [10, 10, -29, 10, 20, 20],
#     [10, 10, 10, -19, 10, 10],
#     [0, 10, 20, 10, -17, 10],
#     [20, 20, 20, 10, 10, -28],
# ]


def readFile(filename: str) -> np.array:
    size: int = 6
    with open(filename, 'r') as f:
        data = [int(x) for x in f.read().split()]
        size = int(data[0])
        p = int(data[1])
        data = data[2:]
        matrix = [data[i:i + size] for i in range(0, len(data), size)]
        return np.array(matrix), p


Qpartition6, Ppartition6 = readFile('files/partition6.txt')
Qgraphe12345, Pgraphe12345 = readFile('files/graphe12345.txt')


# X = [1, 1, 0, 1, 0, 0]
X = new_random_x(len(Qgraphe12345))


def ubqp(q: np.array, x: list) -> int:
    return sum(
        q[i][j] * x[i] * x[j] for i in range(len(x)) for j in range(len(x))
    )

# Program a best_neighbor function that returns the best
# neighbor solution of X where a neighbor X ′ of X is a
# sequence of bits that differs from X by only one bit.


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

# print(best_neighbor(Qgraphe12345, X))


def steepest_hill_climbing(q: np.array, x: list, max_depl: int) -> list:
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


def random_restart_hill_climbing(q: np.array, x: list, max_depl: int, max_restart: int) -> list:
    s_best = x
    s_score_best = ubqp(q, s_best)
    nb_restart = 0
    while nb_restart < max_restart:
        s_prime, s_prime_score = steepest_hill_climbing(
            q, new_random_x(len(Qgraphe12345)), max_depl)
        if s_prime_score < s_score_best:
            s_best = s_prime
            s_score_best = s_prime_score
        nb_restart += 1
    return s_best, s_score_best


# print(random_restart_hill_climbing(Qgraphe12345, X, 100, 100))


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


# Q1.7 Programmer la méthode tabou en essayant différentes tailles pour la liste Tabou.
print(tabu_search(Qgraphe12345, X, 100, 1000))
