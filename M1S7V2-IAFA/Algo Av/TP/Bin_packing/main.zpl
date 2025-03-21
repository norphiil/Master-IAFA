
# Compte-rendu du programme ZIMPL :
#
# Le programme résout un problème d'allocation d'objets dans des boîtes, avec des contraintes de capacité pour chaque boîte.
#
# 1. Traitement des symétries :
#    La question des symétries est partiellement traitée dans le programme grâce à la contrainte "breakSymmetry", qui garantit que les boîtes sont utilisées dans un ordre croissant ou égal. Cependant, cette contrainte ne couvre pas toutes les symétries possibles. Il serait nécessaire d'ajouter des contraintes supplémentaires pour gérer d'autres types de symétries, si cela est requis.
#
# 2. Instances testées :
#    Le programme a été testé sur deux fichiers d'instances : "u20_00.bpa" et "u40_00.bpa".
#
#    Pour "u20_00.bpa" :
#    - Sans la fonction de symétrie, le temps de calcul est de 0.00 seconde.
#    - Avec la fonction de symétrie (grâce à la contrainte "breakSymmetry"), le temps de calcul est de 0.31 seconde.
#
#    Pour "u40_00.bpa" :
#    - Sans la fonction de symétrie, le temps de calcul est de 24.30 secondes.
#    - Avec la fonction de symétrie (grâce à la contrainte "breakSymmetry"), le temps de calcul est de 9.32 secondes.

param fichier := "u60_00.bpa" ;
param C := read fichier as "1n" skip 1 use 1;
param Size := read fichier as "2n" skip 1 use 1;
set Objets := {1 to Size by 1} ;
set Boites := {1 to Size by 1} ;
set tmp[<o> in Objets] := {read fichier as "<1n>" skip 1 + o use 1};
param taille [<o> in Objets] := ord(tmp[o],1,1);
var x[Objets*Boites] binary;
var y[Boites] binary;

minimize y: sum<b> in Boites: y[b];

subto useBoite :
    forall<b> in Boites :
        forall<o> in Objets :
            x[o,b] <= y[b];

subto capaBoite :
    forall<b> in Boites :
        sum<o> in Objets :
            taille[o] * x[o,b] <= C;

subto limAffect :
    forall<o> in Objets :
        sum<b> in Boites :
            x[o,b] == 1;

subto breakSymmetry:
    forall<b> in Boites with b > 1 :
        y[b] <= y[b-1];

