# Introduction à la robotique.

## Cas des systemes a 3 angles

Systeme à 3 angles de rotation (3R) : 3 angles de rotation successifs.

- Principe => Décomposer la rotation complexe en 3 rotations simples
- Selon la decomposition choisie, on a une représentation ou une autre.
- Décomposition possible :
  - Angle de Bryant \
        = 1 rotation autour de l'axe x du repére "local". \
        + 1 rotation autour de l'axe y du repére "local". \
        + 1 rotation autour de l'axe z du repére "local". \
  - Angle d'Euler \
        = 1 rotation autour de l'axe z du repére "local". \
        + 1 rotation autour de l'axe x du repére "local". \
        + 1 rotation autour de l'axe z du repére "local".

Rom = $
\begin{pmatrix}
1 & 0 & 0 \\
0 & 0 & -1 \\
0 & 1 & 0
\end{pmatrix}
 -> x_R =
\begin{pmatrix}
\lambda \\
\mu \\
\nu
\end{pmatrix}
$ \

$r_{13} = 0 => r_{13} \neq +- 1$ Hors singularité \
$\lambda = Atan2 ( r_{23}, {r_{33}}) =>$ \
$Sin(\lambda) = -r_{23} = +1$ \
$Cos(\lambda) = r_{33} = 0$ \
$\lambda = \pi/2$ \
$\mu = Arcsin(r_{13}) = ArcSin(0) = 0$ \
$\nu = Atan2 ( -r_{12}, {r_{11}}) =>
\begin{pmatrix}
sin(\nu) = 0 \\
cos(\nu) = 1
\end{pmatrix} => \nu = 0$

Exemple:
Rom = $\begin{pmatrix}
1 & 0 & 0 \\
0 & 0 & -1 \\
0 & 1 & 0
\end{pmatrix}$ \
$\theta = Arccos(\frac{r_{11} + r_{22} + r_{33} - 1}{2})$ \
$\theta = Arccos(\frac{1 + 0 + 0 - 1}{2}) = Arccos(0) = \frac{k \pi}{2}$

## Matrices de transformation.

* Bilan: \
    On sait repprésenter la situation de l'OT.
    Il nous manque: \
  -  Gérer les changements de repére.
  - Passer de l'espace des config à l'espace opérationnel.

Matrice de transformation: \
NB: Transformation = Rotation + Translation

2 cas:
  1. Rotation seule.
  2. Rotation + Translation.

On considére 2 repére R(à, x, y, z) Fixe et R'(a', x', y', z') Mobile.

### 1) Rotation Seule.
- O = O' (pas de translation)
- x', y', z' ont changé d'orientation / x, y, z : Axes $\neq$ 

=> La rotation effectuée est définie par la matrice de rotation R = $
\begin{pmatrix}
r_{11} & r_{12} & r_{13} \\
r_{21} & r_{22} & r_{23} \\
r_{31} & r_{32} & r_{33}
\end{pmatrix}
$