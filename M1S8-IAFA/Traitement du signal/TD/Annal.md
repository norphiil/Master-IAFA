# Examen 1

## Exercice 1 :

$$\delta(n) = \begin{Bmatrix}
  1 & si ~n = 0 \\
  0 & sinon
 \end{Bmatrix}$$

$$u(n) = \begin{Bmatrix}
  1 & si ~n >= 0 \\
  0 & sinon
 \end{Bmatrix}$$

$$h(n) = \begin{Bmatrix}
  1 & si ~n = 0 \\
  2 & si ~n = 1 \\
  1 & si ~n = 2 \\
  3 & si ~n = 3 \\
  0 & sinon
 \end{Bmatrix}$$

1. **Exprimer h(n) en fonction de plusieurs "Dirac" $\delta(n)$.**

    $$h(n) = \delta(n) + 2\delta(n-1) + \delta(n-2) + 3\delta(n-3)$$

2. **Exprimer h(n) en fonction de plusieurs échelons unités u(n).**

    $$h(n) = u(-n + 3) * (u(n) + u(n-1) + 2u(n-3) - u(n-2))$$

3. **Ce système est-il stable? Justifier.**

    Pour déterminer si le système est stable, nous devons vérifier si la réponse impulsionnelle h(n) est absolument sommable, c'est-à-dire si sa somme infinie converge à une valeur finie.

    Expression en termes de Dirac:
    $$h(n) = \delta(n) + 2\delta(n-1) + \delta(n-2) + 3\delta(n-3) + 0\delta(n-4) + ...$$

    La réponse impulsionnelle h(n) est donc une combinaison pondérée de fonctions de Dirac décalées. Ainsi, la réponse impulsionnelle est absolument sommable et le système est stable.

    Expression en termes d'échelons unitaires:
    $$h(n) = u(-n+3)(u(n) + u(n-1) + 2u(n-3) - u(n-2))$$

    Cette expression est nulle pour n < 0 et pour n > 3. Pour n entre 0 et 3 inclus la réponse impulsionnelle est absolument sommable et le système est stable.

    Ainsi, dans les deux cas, la réponse impulsionnelle est absolument sommable, donc le système est stable.

4. **Ce système est-il causal? Justifier.**

    Pour déterminer si le système est causal, nous devons vérifier si la réponse impulsionnelle h(n) est nulle pour n < 0.

    Expression en termes de Dirac:
    $$h(n) = \delta(n) + 2\delta(n-1) + \delta(n-2) + 3\delta(n-3)$$

    La réponse impulsionnelle h(n) est donc une combinaison pondérée de fonctions de Dirac décalées. Ainsi, la réponse impulsionnelle est nulle pour n < 0 et le système est causal.

    Expression en termes d'échelons unitaires:
    $$h(n) = u(-n+3)(u(n) + u(n-1) + 2u(n-3) - u(n-2))$$

    Cette expression est nulle pour n < 0 et pour n > 3. Pour n entre 0 et 3 inclus la réponse impulsionnelle est nulle pour n < 0 et le système est causal.

    Ainsi, dans les deux cas, la réponse impulsionnelle est nulle pour n < 0, donc le système est causal.

5. **Calculer la réponse de ce système à une entrée $x_{0}(n) = cos(\pi*n) + sin(2 \pi *n / 3).$**

    Dans la suite, on considère que h est constituée que de ses valeurs non nulles.

6. **Soit le signal $x = \begin{bmatrix} 1 & 2 & -1 & 1 \end{bmatrix}$. Calculer la convolution complète $z = h * x$ entre h et x.**

    $$
        h = \begin{bmatrix} 1 & 2 & 1 & 3 \end{bmatrix}
    $$

     |       |   1   |   2   |   1   |   3   |
     | :---: | :---: | :---: | :---: | :---: |
     |   1   |   1   |   2   |   1   |   3   |
     |   2   |  -1   |  -2   |  -1   |  -3   |
     |  -1   |   2   |   4   |   2   |   6   |
     |   1   |   1   |   2   |   1   |   3   |

    $z(n) = \begin{bmatrix} 1 & 4 & 4 & 4 & 9 & -2 & 3 \end{bmatrix}$

7. **Quelle est la taille de z ?**

    len(z) = len(h) + len(x) - 1 = 4 + 4 - 1 = 7

8. **Aurait-on pu prévoir cette taille avant le calcul? Justifier.**

    Oui, car la taille de z est égale à la taille de h plus la taille de x moins 1.

9.  **Calculer la convolution circulaire $w = h ~o ~z$, entre h et z.**

10.  **Quelle est la taille de w?**

11. **Donner la matrice C telle que $w = Cx$.**

## Exercice 2 :

1. **Pourquoi dans la définition de la transformée de Fourier inverse (voir Rappels) les bornes de l'intégrale sont -1/2 et 1/2**

    Les bornes de l'intégrale sont en effet de $-1/2$ à $1/2$, car la transformée de Fourier est periodique donc nous pouvons utiliser les borne $-1/2$ a $1/2$ pour nos calcule.

    Soient les signaux $z(n) = cos(2 \pi *\frac{n}{4} )$ et $h(n) = \frac{(sin(2 \pi*f_{0} * n))}{(\pi * n)}$

2. **Donner les transformées de Fourier X(f) et H(f) resp. de z(n) et h(n).**

    $$X(f) = \frac{1}{2} \left( \delta(f) + \delta(f - \frac{1}{4}) + \delta(f + \frac{1}{4}) \right)$$

    $$H(f) = \frac{1}{2} \left( \delta(f) + \delta(f - f_0) + \delta(f + f_0) \right)$$

3. **Donner l'expression de y(n) = (hx)(n)**
4. **Discuter les valeurs de y(n) selon les valeurs de $f_0$.**

## EXERCICE 3

Pour les deux questions suivantes, on peut répondre directement sur la feuille d'énoncé et la rendre avec sa copie.
Soit le signal $x(n) = 3\delta(n+1)- 5\delta(n) + 3\delta(n-1)$, on note $ X(f)$ sa **transformée de Fourier continue.** Ainsi par exemple $X(0) = X(f)$ pour $f = 0$

Transformée de Fourier continue = $\sum_{-\infty}^{+\infty} x(n) \cdot e^{j2\pi f n}$

1. Compléter le tableau suivant

    |  $n$   |  -2   |  -1   |   0   |   1   |   2   |
    | :----: | :---: | :---: | :---: | :---: | :---: |
    | $x(n)$ |   0   |   3   |  -5   |   3   |   0   |

2. Sans calculer explicitement $X(f)$, compléter le tableau suivant :

    $$
        \begin{array}{c | c | c | c | c}
            X(0) & \int^{1/2}_{-1/2} X(f) df & \int^{1/2}_{-1/2} |X(f)|^2 df & X(1/2) & X(-1/2) \\
            \hline
            \sum_{-\infty}^{+\infty} x(n) & & & \sum_{-\infty}^{+\infty} x(n)*(-1)^n & \sum_{-\infty}^{+\infty} x(n)*(-1)^n
        \end{array}
    $$

## EXERCICE 4

1. **Quelle est la taille d'une image numérique de 128 lignes x 128 colonnes où chaque pixel est codé sur 8 bits ?**

    128 lignes x 128 colonnes = 16384 pixels
    16384 pixels x 8 bits = 131072 bits \
    131072/8 octets = 16384 octets = 16 Ko

    16384 / 16 = 1024 octets

2. **La taille d'une image numérique de 256 x 256 est 64Ko (Kilo-octets), quel est le nombre $Nb$ de bits utilisés pour coder chaque pixel ?**

    256 x 256 = 65536 pixels
    65536 / 64000 o = 1024 octets

    Donc 8 bits

3. **Quelle est la nouvelle taille si chaque pixel est codé sur $Nb - 1$ bits?**

    Si chaque pixel est codée sur 7 bits la nouvelle taille sera de :

    65536 * 7 = 458752 bits = 57344 octets = 56 Ko

4. **Perçoit-t-on une différence ?**

    la réduction de la profondeur de bits peut entraîner une perte de qualité visible.

5. **Expliquer votre réponse précédente.**

6. **Que se passe-t-il si on réduit la taille de sorte à avoir $Nb = 2$ ?**

    Si on réduit la profondeur de bits à 2, cela signifie que chaque pixel peut prendre seulement 4 valeurs possibles (00, 01, 10, 11). Cela entraînera une perte de détails et de nuances de couleur dans l'image, car il y aura moins de variations possibles pour chaque pixel. La taille de l'image sera également réduite, car chaque pixel utilisera maintenant seulement 2 bits, soit 1/4 de la taille originale.
