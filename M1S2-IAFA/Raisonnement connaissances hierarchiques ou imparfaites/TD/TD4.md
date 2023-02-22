# KRR1 Feuille de TD no 4 : Logique Possibiliste

Dans les deux premiers exercices on demande de raisonner en n'utilisant que les principes de
monotonie valable pour les deux mesures $\Pi$ et N ainsi que la dualité et les principes des nécessités
(intersection) et possibilités (union) :

p $\models$ q implique N(p) $\leq$ N(q) (monotonie de N) \
p $\models$ q implique $\Pi$(p) $\leq$ $\Pi$(q) (monotonie de $\Pi$) \
N(p) = 1 - $\Pi$($\neg$p) (dualité) \
N(a $\land$ b) = min(N(a), N(b)) (nécessité) \
$\Pi$(a $\vee$ b) = max($\Pi$(a), $\Pi$(b)) (possibilité) \
N(T) = 1 (masse unitaire)

## Exercice 1 Incertitude sur la fabrication du Piuit

### Les connaissances :

La présence d'un défaut sur un composant annonce généralement une panne prochaine de la chaîne.
Si le test est positif, il y a très certainement un défaut sur le composant Piuit par la chaîne.
Lorsqu'une panne de la chaîne est suspectée, il est très possible qu'elle ne soit plus disponible. Il est
tout à fait certain que si la chaîne n'est pas disponible, le Piuit ne sera pas fabriqué.
Ces connaissances sont traduites en logique possibiliste par les assertions suivantes :

(A1) N(defaut $\to$ panne) $\geq$ 0.6 \
(A2) N(test_pos $\to$ defaut) $\geq$ 0.7 \
(A3) $\Pi$(panne $\to$ pas_dispo) $\geq$ 0.8 \
(A4) N(pas_dispo $\to$ $\neg$fabrique) = 1

où : $\Pi$ dénote une mesure de possibilité et N la mesure de nécessité duale. $\Pi$(p) $\geq$ x (resp. N(p) $\geq$ x)
signifie « la possibilité (resp. nécessité) que p soit vraie est $\geq$ x »

On constate que le test pratiqué est positif. Que peut-on conclure sur (la possibilité ou la nécessité de) :

1) l'existence d'un défaut ?\
    test_pos $\land$ (test_pos $\to$ defaut) $\models$ defaut \
    a $\land$ (a $\to$ b) $\models$ b \
    d'aprés monotonie de N, min(N(test_pos), N(test_pos $\to$ defaut) )$\geq$ 0.7

2) la présence d'une panne de la chaîne ? \
    defaut $\land$ (defaut $\to$ panne) $\models$ panne \
    N(defaut) $\geq$ 0.7 \
    N(defaut $\to$ panne) $\geq$ 0.6 \
    d'aprés monotonie de N, min(N(defaut), N(defaut $\to$ panne) )$\geq$ 0.6

3) l'indisponibilité de la chaîne ? \
    0.8 $\leq$ $\Pi$ (panne $\to$ pas_dispo) = $\Pi$($\neg$ panne $\vee$ pas_dispo) = max($\Pi$ ($\neg$ panne), $\Pi$(pas_dispo)) \
    $\Pi$ ($\neg$ panne) $\leq$ 0.4 \
    $\Rightarrow$ $\Pi$(pas_dispo) $\geq$ 0.8

4) la fabrication du Piuit ? \
    pas_dispo $\to$ $\neg$ fabrique $\equiv$ (équivalent) \
    N(fabrique) $\to$ N(pas_dispo) = 1 (contraposée) \
    fabrique $\land$(fabrique $\to$ $\neg$ pas_dispo) $\models$ $\neg$ pas_dispo (monotonie) \
    N(fabrique $\land$ (fabrique $\to$ $\neg$ pas_dispo)) $\leq$ min(N(fabrique), N(fabrique $\to$ $\neg$ pas_dispo)) $\leq$ N($\neg$ pas_dispo) $\leq$ 0.2 \
    $\Rightarrow$ N(fabrique) $\leq$ 0.2

## Exercice 2 Le déclenchement de l'alarme

/i\\ Important pour la recuperation de donnée dans le text \
N = degré de certitude\
$\Pi$ = degré de possibilité

### Les connaissances :

Lorsque l'alarme se déclenche, il est possible que ce soit dû à une panne machine et il est aussi possible que ce
soit dû à un accident du travail. Il est presque certain qu'une panne machine provoque un arrêt de la
production.
Ces connaissances sont traduites en logique possibiliste par les assertions suivantes :

(A1) $\Pi$(ala $\to$ pan) $\geq$ 0.9 \
(A2) $\Pi$(ala $\to$ acc) $\geq$ 0.7 \
(A3) N(pan $\to$ arr) $\geq$ 0.8
(A4 dans le text) N(ala) $\geq$ 0.8

1) Une source nous permet d'avoir quelque certitude (au moins au degré 0.8) sur le fait que l'alarme a été déclenchée. Que peut-on en conclure sur (la possibilité ou la nécessité) de :

    a) l'existence d'un accident du travail ? \
    $\Pi$($\neg$ala $\vee$ acc) $\geq$ 0.7 \
    $\Pi$($\neg$ala) = 1 - N(ala) $\leq$ 0.2 \
    max($\Pi$($\neg$ala), $\Pi$(acc)) $\geq$ 0.7 \
    $\Pi$(acc) $\geq$ 0.7

    b) l'existence d'une panne machine ? \
    $\Pi$($\neg$ala $\vee$ pan) $\geq$ 0.9 \
    $\Pi$($\neg$ala) = 1 - N(ala) $\leq$ 0.2 \
    max($\Pi$($\neg$ala), $\Pi$(pan)) $\geq$ 0.9 \
    $\Pi$(pan) $\geq$ 0.9

    c) un arrêt de la production ? \
    N(pan $\to$ arr) $\geq$ 0.8 \
    pan $\to$ arr $\equiv$ $\neg$ arr $\to$ $\neg$pan \
    N($\neg$ arr $\to$ $\neg$ pan) $\geq$ 0.8 \
    $\neg$ arr $\land$ ($\neg$ arr $\to$ $\neg$ pan) $\models$ $\neg$ pan \
    (monotonie) \
    min(N($\neg$ arr), N($\neg$ arr $\to$ $\neg$ pan)) $\leq$ N($\neg$ pan) $\leq$ 0.1 \
    $\Rightarrow$ N($\neg$ arr) $\leq$ 0.1
    $\Rightarrow$ $\Pi$(arr) $\geq$ 0.9

2) D'une autre source, nous pouvons affirmer qu'il est possible (au moins au degré 0.6) que la production n'ait pas été arrêtée. Que peut-on en conclure sur l'existence d'une panne machine ?
   $\Pi$ ($\neg$ arr) $\geq$ 0.6 \
   N(arr) $\leq$ 0.4 \
   pan $\land$ (pan $\to$ arr) $\models$ arr \
    (monotonie) \
    min(N(pan), N(pan $\to$ arr)) $\leq$ N(arr) $\leq$ 0.4 \
    $\Rightarrow$ N(pan) $\leq$ 0.4

## Exercice 3 Résolution en logique possibiliste

### Les connaissances sur le capteur de température :

(C1) Si la température est normale, alors l'alarme ne sonne pas. \
(C2) Si le voyant est rouge et que le capteur fonctionne, alors la température est élevée. \
(C3) Le voyant est rouge \
(C4) Si le voyant est rouge, l'alarme sonne. \
(C5) Le capteur fonctionne \
(C6) La température est normale

### Le vocabulaire logique :

|  OK   |   le capteur fonctionne   |
| :---: | :-----------------------: |
| CHAUD | la tempétature est élevée |
| rouge |   le voyant est rouge,    |
| sonne |      l'alarme sonne       |

L'incertitude des connaissances est exprimée comme suit :
   - L'assertion C3 est tout à fait certaine.
   - Les assertions C1 et C2 sont quasi-certaines (au moins au degré 0.9).
   - L'assertion C4 est certaine au moins au degré 0.7.
   - L'assertion C5 est certaine au moins au degré 0.6.
   - L'assertion C6 est peu certaine (au moins au degré 0.5 seulement).

1) Ecrire les connaissances sous la forme d'une base de clauses possibilistes BP. \
   
    C1 $\neg$ CHAUD $\to$ $\neg$ sonne 0.9\
    C2 rouge $\land$ OK $\to$ CHAUD 0.9 \
    C3 rouge 1.0 \
    C4 rouge $\to$ sonne 0.7 \
    C5 OK 0.6 \
    C6 $\neg$ CHAUD 0.5

    Clauses : \
    $\neg$ CHAUD $\vee$ $\neg$ sonne 0.9 \
    $\neg$rouge $\vee$ $\neg$ OK $\vee$ CHAUD 0.9 \
    rouge 1.0 \
    $\neg$rouge $\vee$ sonne 0.7 \
    OK 0.6 \
    $\neg$CHAUD 0.5

2) Déterminer le degré d'inconsistance de BP. \
    

3) Que peut-on conclure et avec quelle certitude parmi les littéraux suivants : sonne, $\neg$sonne,
CHAUD, $\neg$CHAUD ? \


4) Une source confirme l'hypothèse C6 dont la certitude augmente au moins au degré 0.8. Que peut-on maintenant conclure ? \