# Connaissances incomplètes et Hypothèse du monde clos (CWA)

## I - Révisions de logique

### A) Logique propositionnelle

#### 1) Montrer par une preuve sémantique que la déduction suivante est valide (vous pouvez utiliser un tableau pour lister les interprétations). $h, h \to (p \vee q), p \to c, q \to c \models c$

|  h  |  p  |  q  |  c  |  h  | $h \to (p \vee q)$ | $p \to c$ | $q \to c$ |  A  |  c  |
| :-: | :-: | :-: | :-: | :-: | :----------------: | :-------: | :-------: | :-: | :-: |
|  V  |  V  |  V  |  V  |  V  |         V          |     V     |     V     |  V  |  V  |
|  V  |  V  |  V  |  F  |  V  |         V          |     F     |     F     |  F  |  F  |
|  V  |  V  |  F  |  V  |  V  |         V          |     V     |     V     |  V  |  V  |
|  V  |  V  |  F  |  F  |  V  |         V          |     F     |     V     |  F  |  F  |
|  V  |  F  |  V  |  V  |  V  |         V          |     V     |     V     |  V  |  V  |
|  V  |  F  |  V  |  F  |  V  |         V          |     V     |     F     |  F  |  F  |
|  V  |  F  |  F  |  V  |  V  |         F          |     V     |     V     |  F  |  F  |
|  V  |  F  |  F  |  F  |  V  |         F          |     V     |     V     |  F  |  F  |
|  F  |  V  |  V  |  V  |  F  |         V          |     V     |     V     |  F  |  F  |

#### 2) Même question mais avec une preuve syntaxique.

(Rappel : $a \to b = \neg a \vee b $)

Mettre A sous forme FNC.

$h, h \to (p \vee q), p \to c, q \to c \models c$

C1 : h \
C2 : $\neg h \vee (p \vee q)$ \
C3 : $\neg p \vee c$ \
C4 : $\neg q \vee c$ \
C5 : $\neg c$ (supposition pour réfutation) \
C6 : $C1RC2$ = $p \vee q$ \
C7 : $C3RC6$ = $q \vee c$ \
C8 : $C7RC4$ = $c \vee c$ = $c$ \
C9 : $C8RC5$ = $\perp$

$A, \neg c \models \perp \iff A \models c$

#### 3) Donner le statut de la formule $\varphi = (p \to q) \to ((\neg p \to q) \to \neg q)$ par une étude sémantique

2 variable propositionnelles p et q
4 interprétations

|  p  |  q  | $\neg p$ | $\varphi$ | $\varphi$ |
| :-: | :-: | :------: | :-------: | :-------: |
|  V  |  V  |    F     |     V     |     F     |
|  V  |  F  |    F     |     V     |     V     |
|  F  |  V  |    V     |     V     |     F     |
|  F  |  F  |    V     |     V     |     V     |

$\varphi$ est satisfiable et non valide.

#### 4) Montrer syntaxiquement que $\varphi \models p \to \neg q$.

$\varphi = \neg (p \to q) \vee ((\neg p \to q) \to \neg q)$ \
$\varphi = (p \wedge \neg q) \vee (\neg (\neg p \to q) \vee \neg q)$ \
$\varphi = (p \wedge \neg q) \vee (\neg p \wedge \neg q) \vee \neg q$ \

### B) Logique des prédicats

#### 1) Donner le domaine de Herbrand associé à l'inférence suivante, le nombre d'interprétations de Herbrand et proposez une interprétation de Herbrand qui satisfait la partie gauche de l'inférence. Vérifiez sa validité. $ \forall X, (p(X) \vee q(X)) \wedge p(a) \vee q(b) \models \forall X, p(X) \vee \forall Y, q(Y) $

$ D_h(A) = \{a, b\} $
Interprétation de Herbrand : $I_h = \{p(a), p(b), q(b), q(b)\}$
