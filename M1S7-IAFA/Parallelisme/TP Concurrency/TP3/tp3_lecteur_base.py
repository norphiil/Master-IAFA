import sys
import time
import random
from multiprocessing import Process, Lock, Condition, Value

# En assurant une synchronisation de type moniteur, écrire les opérations start_* et end_* de
# manière à ce que les processus s'exécutent dans l'ordre d'arrivée, et que les lecteurs arrivant avant
# le premier rédacteur en attente s'exécutent en parallèle.
# Pour cela implémentez une classe ExtendedCondition (utilisant en interne des Conditions
# classiques) offrant les capacités suivantes :
# • Possibilité de gérer la priorité forte (i.e. le wait(0)) en plus de la priorité normale (ie le
# wait(1) ou wait()). On se limite ici au cas de conditions à 2 niveaux de priorité.
# • Possibilité de vérifier si la liste d'attente est vide (i.e. le .empty())
# Remarque : Repartez du squelette de code fourni dans le fichier tp2_lectred_base.py
# On rappelle qu'en python une fonction peut prendre une valeur par défaut pour ses arguments :
# def wait(priority = 1):
# Si wait est appelé sans argument alors priority vaudra 1, sinon priority prendra la valeur
# de l'argument.


class ExtendedCondition:
    def __init__(self, lock: Lock) -> None:
        self.cond_prio = Condition(lock)
        self.cond_prio_nb: Value = Value('i', 0)
        self.cond = Condition(lock)

    def wait(self, priority: int = 1) -> None:
        if priority == 1:
            self.cond_prio_nb.value += 1
            self.cond_prio.wait()
            self.cond_prio_nb.value -= 1
        else:
            self.cond.wait()

    def notify(self) -> None:
        with self.cond_prio:
            if self.cond_prio_nb.value != 0:
                self.cond_prio.notify()
            else:
                self.cond.notify()


class RW:
    def __init__(self):
        self.lock: Lock = Lock()
        self.nb_read: Value = Value('i', 0)
        self.cond_read: ExtendedCondition = ExtendedCondition(self.lock)
        self.cond_write: ExtendedCondition = ExtendedCondition(self.lock)
        self.writing_on: Value = Value('i', 0)
        self.reading_on: Value = Value('i', 0)
        self.cpt: Value = Value('i', 0)

    def start_read(self):
        with self.lock:
            while (self.writing_on.value == 1 or self.cpt.value > 0):
                self.cond_read.wait(1)
            self.nb_read.value += 1
            self.cond_read.notify()

    def end_read(self):
        with self.lock:
            self.nb_read.value -= 1
            if (self.nb_read.value == 0):
                self.cond_write.notify()

    def start_write(self):
        with self.lock:
            while (self.writing_on.value == 1 or self.nb_read.value > 0):
                self.cpt.value += 1
                self.cond_write.wait(0)
                self.cpt.value -= 1
            self.writing_on.value = int(1)

    def end_write(self):
        with self.lock:
            self.writing_on.value = int(0)
            self.cond_read.notify()
            self.cond_write.notify()


def process_writer(identifier, synchro):
    synchro.start_write()
    for _ in range(5):
        with open('LectRed_shared', 'a') as file_id:
            txt = ' '+str(identifier)
            file_id.write(txt)
            print('Writer', identifier, 'just wrote', txt)
        time.sleep(.1 + random.random())
    synchro.end_write()


def process_reader(identifier, synchro):
    synchro.start_read()
    position = 0
    result = ''
    while True:
        time.sleep(.1 + random.random())
        with open('LectRed_shared', 'r') as file_id:
            file_id.seek(position, 0)
            txt = file_id.read(1)
            if len(txt) == 0:
                break
            print('Reader', identifier, 'just read', txt)
            result += txt
            position += 1
    print(str(identifier)+':', result)
    synchro.end_read()


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: %s <Nb reader> <Nb writer> \n" % sys.argv[0])
        sys.exit(1)

    nb_reader = int(sys.argv[1])
    nb_writer = int(sys.argv[2])

    synchro = RW()

    # To initialize the common data
    with open('LectRed_shared', 'w') as file_id:
        file_id.write('')

    processes = []
    for id_writer in range(nb_writer):
        writer = Process(target=process_writer, args=(id_writer, synchro))
        writer.start()
        processes.append(writer)

    for id_reader in range(nb_reader):
        reader = Process(target=process_reader, args=(id_reader, synchro))
        reader.start()
        processes.append(reader)

    for process in processes:
        process.join()
