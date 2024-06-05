# Examen Session 2

## RAPPELS

On rappelle les signaux élémentaires suivants :

L'impulsion de Dirac :
$$ 
    \delta(n)= \begin{Bmatrix} 1 & si ~n = 0\\ 0&sinon. \end{Bmatrix}
$$

L'échelon unité :
$$
    u(n) = \begin{Bmatrix} 1 & si ~n >= 0 \\ 0 & sinon. \end{Bmatrix}
$$
On rappelle la transformée de Fourier Discrète (TFD) d'un signal discret $x(n)$ de N valeurs et sa transformée inverse :

$$
    X(k) = \sum_{n = 0}^{N - 1} x(n) * e^{- 2j \pi nk / N} \\
    x(n) = (1/N) \sum_{n = 0}^{N-1} X(k) * e^{2j \pi nk / N} \\
    n, k = 0, 1, 2 ,...N-1
$$
On rappelle la transformée de Fourier Continue (TFC) d'un signal discret x(n) et sa transformée inverse :
$$
    X(f) = \sum_{n = -\infty}^{+\infty} x(n) * e^{- 2j \pi nf} \\
    x(n) = \int^{1/2}_{-1/2} X(f) * e^{2j \pi nf} df
$$

## EXERCICE 1: SYSTEMES

On considère un système T d'entree $x(n)$ et de sortie $y(n) = exp[x(n)]$.

1. **Ce système est-il linéaire ?**

   Lineaire ? \
  $T[\alpha_1 x_1(n) + \alpha_2 x_2(n)]$\
   =$e^{(\alpha_1 x_1(n) + \alpha_2 x_2(n))}$\
   =$e^{\alpha_1 x_1(n)}e^{\alpha_2 x_2(n)}$\
   =$T[x_1(n)] T[x_2(n)] \neq \alpha_1 T[x_1(n)] + \alpha_1 T[x_2(n)]$
   Il n'est donc pas linéaire.

2. **Ce système est-il invariant temporel ?**

   Invariant par translation ? \
    $T[x(n - n_0)] = e^{x(n - n_0)}$\

    donc Oui c'est un system Invariant par translation !

3. **Ce système est-il causal ?**

   Casual ? \
    Oui si T[x(n_0)] = combinaison de x(n) et/ou de y(n) avec n$\leq$ n_0 \
    c'est bien le cas ici car y(n) = T[x(n)] ne dépend que de x(n), donc oui c'est un système Casual.

4. **Donner sa réponse impulsionnelle h(n)**

    $$
        h(n) = T[\delta(n)] = e^{\delta(n)} = \begin{Bmatrix} e^1 & si ~n = 0\\ e^0 & sinon. \end{Bmatrix}
    $$

5. **Montrer que $h(n) \ne 0$ pour tout $n < 0$**

    $$
        \forall n < 0 : h(n) = e^{\delta(n)} = e^0 = 1 \neq 0
    $$

6. **Un de vos camarades vous affirme que pour un système causal, on devrait avoir $h(n) = 0$ pour tout $n < 0$ Expliquez-lui son erreur dans le cas de la question précédente.**

    Pour un systeme causal lineaire son affirmation est vraie, mais ici le systeme n'est pas lineaire, donc sa réponse impulsionnelle n'est pas nulle pour tout n < 0, donc mon camarade a tort et ne connait pas son cours.

7. **On appelle réponse indicielle d'un système, la réponse de ce système à un échelon unité. On considère un système linéaire invariant temporel (SLIT) de réponse impulsionnelle h(n) et de réponse indicielle g(n) On donne g(n) = 2 ^ n pour tout n. Donner l'expression de h(n).**

## EXERCICE 2: CONVOLUTION

1. Soient les signaux $x_{1} = \begin{bmatrix} 1 & -2 & -1 & 1 \end{bmatrix}^T$ et $x_{2} = \begin{bmatrix} 1 & 2 & 3 & 4 \end{bmatrix}^T$ Calculer $x_{3} = x_{1}*x_{2}$ la convolution complète entre $x_{1}$ et $x_{2}$.

    |       |   1   |   2   |   3   |   4   |
    | :---: | :---: | :---: | :---: | :---: |
    |   1   |   1   |   2   |   3   |   1   |
    |  -2   |  -2   |  -4   |  -6   |  -8   |
    |  -1   |  -1   |  -2   |  -3   |  -4   |
    |   1   |   1   |   2   |   3   |   4   |

    $x_{3} = \begin{bmatrix} 1 & 1 & -1 & -2 & -7 & -5 & 1 \end{bmatrix}$

2. Quelle est la taille de $x_3$.

    $x_3$ est un vecteur de taille 7.

3. Calculer $x_{4} = x_{1} o x_{2}$ la convolution circulaire entre $x_{1}$ et $x_{2}$

    N = len(x1) = len(x2) = 4
    $$
        x_4(0) = 1*1 + -2*4 + -1*3 + 1*2 \\
        x_4(1) = 1*2 + -2*1 + -1*4 + 1*3 \\
        x_4(2) = 1*3 + -2*2 + -1*1 + 1*4 \\
        x_4(3) = 1*4 + -2*3 + -1*2 + 1*1
    $$
    $$
        x_4 = \begin{bmatrix}
            -8 & -1 & 2 & -3
        \end{bmatrix}
    $$

4. Donner la matrice $H$ telle que $x_{4} = H * x_{1}$ où les vecteurs $x_{4}$ et $x_{1}$ sont définis dans la question précédente.

    $$
        H = \begin{bmatrix}
                1 & 4 & 3 & 2 \\
                2 & 1 & 4 & 3 \\
                3 & 2 & 1 & 4 \\
                4 & 3 & 2 & 1
            \end{bmatrix}
    $$

5. Soient les signaux $x(n) = (1/2) ^ n *u(n)$ et $h(n) = u(n)$ avec $n =...,-2,-1,0,1,2,....$ Calculer $w(n) = (h* x)(n)$.

6. Soit $g(n) = u(n) - u(n - 1)$ représenter $g(n)$.
   
7. Calculer $z(n) = (gx)(n)$
   
8. Calculer les transformées de Fourier continue $Z(f)$, $G(f)$, $X(f)$ respectivement de $z(n)$, $g(n)$ et $x(n)$
   
9.  Comparer $Z(f)$, $G(f)$, $X(f)$ et conclure.

## EXERCICE 3, TRANSFORMÉE DE FOURIER DICRÈTE, PROPRIÉTÉS

1. La transformée de Fourier discrète d'un signal discret de N points est-elle périodique? Si oui quelle est cette période. Sinon dire pourquoi.
On note W_{N} ^ (nk) = e ^ (- 2j*pi*nk / N) . Dans la suite on pose N = 5

   1. Soit x(n) = delta(n - 2) + delta(n - 3) Calculer sa transformée de Fourier discrète X(k) en fonction de W_{5}

   2. soit Y(k) = X ^ 2 * (k) où X(k) est définie dans la question précédente. Trouver y(n) la transformée de Fourier discrète inverse de Y(k).
