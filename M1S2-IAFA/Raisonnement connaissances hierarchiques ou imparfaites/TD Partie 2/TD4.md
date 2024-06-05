# TD 4

## Exercice 1 : énoncé

### Les voisins (traduction LPO)

1. $\neg$ blond (Ceux qui ne sont pas blonds)

   x/ $\neg$ blond(x)

2. $\exists$ aime. blond (Ceux qui aiment un blond)

   x/ $\exists$ y.(blond(y) $\land$ aime(x,y))

3. $\forall$ aime. blond (Ceux qui, s'ils aiment qq-un, n'aiment que les blonds)

    x/ $\forall$ y.(aime(x,y) $\rightarrow$ blond(y))

4. blond $\cap$ $\exists$ voisinDe. $\neg$ blond (Les blonds qui ont un voisin qui n'est pas blond)

    x/ blond(x) $\land$ $\exists$ y.(voisinDe.(x,y) $\land$ $\neg$ blond(y))

5. $\forall$ aime. ($\neg$ blond $\cap$ $\exists$ voisinDe. blond) (Ceux qui n'aiment que ceux qui ne sont pas blonds et qui ont un voisin blond)

    x/ $\forall$ y.(aime(x,y) $\rightarrow$ ($\neg$ blond(y) $\land$ $\exists$ z.(voisinDe.(y,z) $\land$ blond(z))))

6. $\exists$ aime. (blond $\cap$ $\exists$ voisinDe. $\neg$ blond) (Ceux qui aiment un blond qui a un voisin qui n'est pas blond)

    x/ $\exists$ y.(aime(x, y) $\land$ blond(y) $\land$ $\exists$ z.(voisinDE(y, z) $\land$ $\neg$ blond(z)))

7. $\forall$ aime. ($\neg$ blond $\cup$ $\exists$ voisinDe. blond) (Ceux qui n'aiment qq-un, qui n'est pas blond ou qq-un qui a un voisin blond)

    x/ $\forall$ y.(aime(x, y) $\rightarrow$ ($\neg$ blond(y) $\lor$ $\exists$ z.(voisinDe.(y, z) $\land$ blond(z))))

8. Traduire en LPO « Ceux qui aiment tous les blonds ». Le traduire ensuite en LD - rappel : x.A(x)$\forall$ $\equiv$ $\neg$( x. $\neg$A(x))$\exists$ . Quel problème cela pose-t-il ? Comment le résoudre ?

    x/ $\forall$ y.(blond(y) $\rightarrow$ aime(x, y)) $\equiv$ $\neg$ ( $\exists$ y.(blond(y) $\land$ $\neg$ aime(x, y))) $\equiv$ $\neg$ ($\exists$ y.($\neg$ aime(x, y) $\land$ blond(y)))

    qui donnerait, en LD : $\neg$ ($\exists$ y.($\neg$ aime(x, y) $\land$ blond(y)))

9. $\exists$ aime. (blond $\cup$ $\exists$ voisinDe. $\neg$ blond) (Ceux qui aiment un blond ou quelqu'un qui a un voisin qui n'est pas blond)

    x/ $\exists$ y.(aime(x, y) $\land$ (blond(y) $\lor$ $\exists$ z.(voisinDe.(y, z) $\land$ $\neg$ blond(z))))

10. $\exists$ aime. $\exists$ aime. $\exists$ voisinDe. $\neg$ blond (Ceux qui aiment quelqu'un qui aime quelqu'un qui a un voisin qui n'est pas blond)

    x/ $\exists$ y.(aime(x, y) $\land$ $\exists$ z.(aime(y, z) $\land$ $\exists$ w.(voisinDe.(z, w) $\land$ $\neg$ blond(w))))

## Exercice 2 : énoncé

### Cyclistes et musiciens. Traduire en LPO

1. $\neg$ musicien (Ceux qui ne sont pas musiciens)

    $\neg$ musicien(x)

2. musicien $\cap$ $\exists$ voisinDe. $\neg$ musicien (Les musiciens qui ont un voisin qui n'est pas musicien)

    musicien(x) $\land$ $\exists$ y.(voisinDe.(x, y) $\land$ $\neg$ musicien(y))

3. musicien $\cap$ $\exists$ connaît. cycliste ( Les musiciens qui connaissent un cycliste)

    musicien(x) $\land$ $\exists$ y.(connaît(x, y) $\land$ cycliste(y))

4. cycliste $\cap$ $\exists$ connaît$-$. musicien ( Les cyclistes qui sont connus par un musicien)

    cycliste(x) $\land$ $\exists$ y.(connaît(y, x) $\land$ musicien(y))

5. cycliste $\cap$ $\neg$ musicien $\cap$ $\forall$ connaît. musicien ( Les cyclistes non musiciens qui ne connaissent que des
musiciens)

    cycliste(x) $\land$ $\neg$ musicien(x) $\land$ $\forall$ y.(connaît(x, y) $\rightarrow$ musicien(y))

6. musicien $\cap$ connaît$-$. musicien$\forall$ (Les musiciens qui ne sont connus que par des musiciens)

    musicien(x) $\land$ $\forall$ y.(connaît(y, x) $\rightarrow$ musicien(y))

## Exercice 3 : énoncé

### L'Université. Traduire en LPO

#### Partie 1

1. Chaque département est dirigé par une personne

   Dept $\subseteq$ ( $\exists$ Dirige$-$ )

    $\forall$ x.(Dept(x) $\rightarrow$ ( $\exists$ y.(Dirige(y, x))))

2. Chaque enseignant enseigne à d'autres personnes

    Enseignant $\subseteq$ ( $\exists$ EnseigneA)

    $\forall$ x.(Enseignant(x) $\rightarrow$ ( $\exists$ y.(EnseigneA(x, y))))

3. Chaque enseignant enseigne une matière

    Enseignant $\subseteq$ ( $\exists$ Enseigne)

    $\forall$ x.(Enseignant(x) $\rightarrow$ ( $\exists$ y.(Enseigne(x, y))))

4. Chaque matière est dirigée par un responsable

    Cours $\subseteq$ ( $\exists$ Responsable$-$)

    $\forall$ x.(Cours(x) $\rightarrow$ ( $\exists$ y.(Responsable(y, x))))

#### Partie 2

1. Les classes Administratif et Enseignant sont disjointes

    Enseignant $\subseteq$ $\neg$ administratif \
    $\forall$ x.(Enseignant(x) $\rightarrow$ $\neg$ administratif(x))

2. Si X Enseigne Y, alors X est un enseignant et Y est une matière

    $\exists$ Enseigne $\subseteq$ Enseignant \
    $\exists$ Enseigne$-$ $\subseteq$ Matière

    $\forall$ x.(Enseigne(x, y) $\rightarrow$ (Enseignant(x) $\land$ Matière(y)))

3. Si X Responsable de Y, alors X est un professeur et Y est une matière

    $\exists$ Responsable $\subseteq$ Professeur \
    $\exists$ Responsable$-$ $\subseteq$ Matière

    $\forall$ x.(Responsable(x, y) $\rightarrow$ (Professeur(x) $\land$ Matière(y)))

4. Si X EnseigneA Y, alors X est un enseignant et Y est un étudiant

    $\exists$ EnseigneA $\subseteq$ Enseignant \
    $\exists$ EnseigneA$-$ $\subseteq$ Etudiant

    $\forall$ x.(EnseigneA(x, y) $\rightarrow$ (Enseignant(x) $\land$ Etudiant(y)))

5. Si X Dirige Y, alors X est un administratif et Y est un département

    $\exists$ Dirige $\subseteq$ Administratif \
    $\exists$ Dirige$-$ $\subseteq$ Departement

    $\forall$ x.($\exists$ y.(Dirige(x, y) $\rightarrow$ (Administratif(x) $\land$ Departement(y))))

6. Si X responsable de Y, alors X enseigne Y

    $\exists$ Responsable $\subseteq$ Enseigne \
    $\exists$ Responsable $\subseteq$ Enseigne

    $\forall$ x.($\exists$ y.(Responsable(x, y) $\rightarrow$ Enseigne(x, y)))

7. Tout département a un directeur

    Département $\subseteq$ $\exists$ Dirige$-$

    $\forall$ x.(Departement(x) $\rightarrow$ ( $\exists$ y.(Dirige(y, x))))

8. Un département d'enseignement ne peut être dirigé que par un professeur

    $\exists$ Dirige. DépartEnseignement $\subseteq$ Professeur

    $\forall$ x.($\exists$ y.(Dirige(x, y) $\land$ DepartEnseignement(y)) $\rightarrow$ Professeur(x))

9. Seuls des professeurs ou des chercheurs peuvent enseigner à des étudiants de master

    $\exists$ EnseigneA. EtudiantM $\subseteq$ Professeur $\cup$ Chercheur

    $\forall$ x.($\exists$ y.(EnseigneA(x, y) $\land$ EtudiantM(y)) $\rightarrow$ (Professeur(x) $\lor$ Chercheur(x)))

10. Ceux qui n'enseignent qu'à des étudiants de Master ou de Licence sont des professeurs

    $\forall$ EnseigneA. (EtudiantM $\cup$ EtudiantL) $\subseteq$ Professeur

    $\forall$ x.( $\forall$ y.(EnseigneA(x, y) $\rightarrow$ (EtudiantM(y) $\lor$ EtudiantL(y))) $\rightarrow$ Professeur(x))

11. Un moniteur qui enseigne à des étudiants de Licence est un doctorant

    ( $\exists$ EnseigneA. EtudiantL) $\cap$ Moniteur $\subseteq$ Doctorant

    $\forall$ x.($\exists$ y.(EnseigneA(x, y) $\land$ EtudiantL(y)) $\land$ Moniteur(x) $\rightarrow$ Doctorant(x))
