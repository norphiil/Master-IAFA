# TD 1 - Introduction au traitement du signal, aux signaux sonores et aux images (IT3SI)

## Exercice 1 :

On considère un système discret d'entrée 𝑥(𝑛) et de sortie 𝑦(𝑛) :
x(n) --> [T] --> y(n) = T[x(n)]

### Question 1 :

Pour chacun des systèmes suivants, dire s'il est linéaire, causal, invariant par translation ou Stable.

1. $y(n) = x(n) + x(n - 1)$

   **Lineaire** ? \
   $T[\alpha_1 x_1(n) + \alpha_2 x_2(n)]$ \
   =$\alpha_1 x_1(n) + \alpha_2 x_2(n) + \alpha_1 x_1(n-1) + \alpha_2 x_2(n-1)$ \
   =$\alpha_1 (x_1(n) + x_1(n-1)) + \alpha_2 (x_2(n) + x_2(n-1))$\
   =$\alpha_1 T[x_1(n)] + \alpha_2 T[x_2(n)]$\
   Donc Oui c'est un systeme linéaire.

   **Casual** ? \
    Oui si T[x(n_0)] = combinaison de x(n) et/ou de y(n) avec n$\leq$ n_0 \
    c'est bien le cas ici car y(n) = T[x(n)] ne dépend que de x(n) et x(n-1).

   **Invariant par translation** ? \
    T[x(n - n_0)] = x(n - n_0) + x(n - n_0 - 1) \
    = y(n - n_0) donc Oui c'est un system Invariant par translation !

   **Stable** ? \
   Entrée bornée -> A > 0 \
  $\forall n \in \mathbb{N}$,$|x(n)| \leq A$\
   $|y(n)| = |T[x(n)]| = |x(n) + x(n-1)| \leq |x(n)| + |x(n-1)|$\
    =>$|y(n)| \leq 2A < \infty$\
    donc y(n) est borné et donc oui c'est un system Stable !

2. $y(n) = exp(x(n))$

   **Lineaire** ? \
  $T[\alpha_1 x_1(n) + \alpha_2 x_2(n)]$\
   =$e^{(\alpha_1 x_1(n) + \alpha_2 x_2(n))}$\
   =$e^{\alpha_1 x_1(n)}e^{\alpha_2 x_2(n)}$\
   =$T[x_1(n)] T[x_2(n)] \neq T[x_1(n)] + T[x_2(n)]$
   Il n'est donc pas linéaire.

   **Casual** ? \
    Oui si T[x(n_0)] = combinaison de x(n) et/ou de y(n) avec n$\leq$ n_0 \
    c'est bien le cas ici car y(n) = T[x(n)] ne dépend que de x(n), donc oui c'est un systeme Casual.

   **Invariant par translation** ? \
    T[x(n - n_0)] = e^(x(n - n_0)) \
    = e^(x(n) - n_0) donc Oui c'est un system Invariant par translation !

   **Stable** ? \
    Entrée bornée -> A > 0 \
   $\forall n \in \mathbb{N}$,$|x(n)| \leq A$\
   $|y(n)| = |T[x(n)]| = |e^{x(n)}|$\
   $|y(n)| \leq e^A < \infty$\
    donc y(n) est borné et donc oui c'est un system Stable !

3. $𝑦(𝑛) = 𝑥(-𝑛)$

   **Lineaire** ? \
   $T[\alpha_1 x_1(n) + \alpha_2 x_2(n)]$\
    =$x_1(-n) + x_2(-n)$\
    =$T[x_1(n)] + T[x_2(n)]$\
    Donc Oui c'est un systeme linéaire.

   **Casual** ? \
    Oui si T[x(n_0)] = combinaison de x(n) et/ou de y(n) avec n$\leq$ n_0 \
    Soit$n_0 < 0$\
   $y(n_0) = x(-n_0)$\
    La sortie à l'instant$n_0$ s'éxprime uniquement en fonction de$x(n_0)$ alors$-n_0 > n_0$ donc à un instant superieur à$n_0$ donc Non Causal.

   **Invariant par translation** ? \
   $T[x(n - n_0)] = y(n - n_0)$\
   $T[x(n)] = x(-n_0)$\
   $T[x(n - n_0)] = x(-n - n_0)$ (on applique pas le changement de signe sur le n_0) \
   (il faut posée$x_1(n) = x(n-n_0)$) \
   Donc Non c'est pas un system Invariant par translation !

   **Stable** ? \
    Entrée bornée -> A > 0 \
   $\forall n \in \mathbb{N}$,$|x(n)| \leq A$\
   $|y(n)| = |T[x(n)]| = |x(-n)|$\
   $|y(n)| \leq A < \infty$\
    Donc y(n) est borné et donc oui c'est un system Stable !

4. $𝑦(𝑛) = \Sigma^n_{k=-\infty} 𝑥(𝑘)$

   **Lineaire** ? \
  $T[\alpha_1 x_1(n) + \alpha_2 x_2(n)]$\
   =$\Sigma^n_{k=-\infty} \alpha_1 x_1(k) + \alpha_2 x_2(k)$\
   =$\alpha_1 \Sigma^n_{k=-\infty} x_1(k) + \alpha_2 \Sigma^n_{k=-\infty} x_2(k)$\
   =$\alpha_1 T[x_1(n)] + \alpha_2 T[x_2(n)]$\
   Donc Oui c'est un systeme linéaire.

   **Casual** ? \
    Oui si T[x(n_0)] = combinaison de x(n) et/ou de y(n) avec n$\leq$ n_0 \
    c'est bien le cas ici car y(n) = T[x(n)] ne dépend que de x(n), donc oui c'est un systeme Casual.

   **Invariant par translation** ? \
   $T[x(n - n_0)] = \Sigma^n_{k=-\infty} x(k - n_0)$ \
   $= \Sigma^n_{k=-\infty} x(k)$ donc Oui c'est un system Invariant par translation !

   **Stable** ? \
   Entrée bornée -> A > 0 \
  $\forall n \in \mathbb{N}$,$|x(n)| \leq A$\
  $|y(n)| = |T[x(n)]| = |\Sigma^n_{k=-\infty} x(k)|$\
  $|y(n)| \leq \Sigma^n_{k=-\infty} A < \infty$\
   donc y(n) est borné et donc oui c'est un system Stable !

   Le système décrit par l'équation $𝑦(𝑛) = \sum^n_{k=-\infty} 𝑥(𝑘)$ est appelé un système de sommation infinie. Ce système est un exemple de système linéaire invariant dans le temps, car il est linéaire (la sortie est une somme pondérée des entrées) et invariant dans le temps (les coefficients de pondération ne dépendent pas de 𝑛).

   Cependant, ce système n'est pas stable, car la somme infinie peut diverger pour certaines entrées. Par exemple, si $x(k) = 1$ pour tout $k$, alors la sortie $y(n)$ divergera car la somme infinie sera infinie. De même, si $x(k) = (-1)^k$, alors la somme oscillera entre 0 et 1, ce qui n'est pas borné.

   En général, pour qu'un système linéaire soit stable, la sortie doit être bornée pour toutes les entrées bornées. Dans le cas du système de sommation infinie, la sortie peut ne pas être bornée pour certaines entrées bornées, ce qui rend le système instable.