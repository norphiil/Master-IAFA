# Soutient 2nd session

## Minimisation des contraintes

$
Min(f(x, y))
\\
(x, y) ∈ IR^2
\\
g(x, y) = 0 <- ~constraint
\\
g(x, y) = 2x + 3y = 5
\\
g(x, y) = 2x + 3y - 5 = 0
\\
L(x, y, λ) = f(x, y) + λg(x, y)
\\
On ~introduit ~la ~fonction ~de ~Lagrange
\\
L(x, y, λ) = f(x, y) + λg(x, y)
\\
CN ~1^{er} ordre ~:
\\
\nabla L(x, y, λ) = \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix} => (\bar{x}, \bar{y}, \bar{λ}) + qualification ~des ~contraintes.
\\
Pour ~chaque ~(\bar{x}, \bar{y}) ~on ~a ~:
\begin{cases} g(\bar{x}, \bar{y}) = 0 \\ \nabla g(\bar{x}, \bar{y}) ~!= \begin{bmatrix} 0 \\ 0 \end{bmatrix}  \end{cases}
\\
CS ~2^{ème} ~ordre ~: ~\nabla^2 L(x, y, λ)
\\
det(\nabla^2 L(\bar{x}, \bar{y}, \bar{λ})) > 0 ~Alors ~(\bar{x}, \bar{y}, \bar{λ}) ~est ~un ~max
det(\nabla^2 L(\bar{x}, \bar{y}, \bar{λ})) < 0 ~Alors ~(\bar{x}, \bar{y}, \bar{λ}) ~est ~un ~min
\\
det A = \begin{vmatrix} a_{11} & a_{12} & a_{13} \\ a_{21} & a_{22} & a_{23} \\ a_{31} & a_{32} & a_{33} \end{vmatrix}
\\
= a_{11}a_{22}a_{33} + a_{12}a_{23}a_{31} + a_{13}a_{21}a_{32} - a_{13}a_{22}a_{31} - a_{12}a_{21}a_{33} - a_{11}a_{23}a_{32}
$

## Qualification bayésienne :

$
1- ~Proba ~a ~priori ~: ~P(w_i)
\\
2- ~Vraisemblance ~: ~P(x | w_i)
\\
p(w_i | x) = \frac{1}{2\pi\sigma^2} \exp \left( - \frac{1}{2}(x - m_i)^T \Sigma_1^{-1}(x-m_i) \right)
\\
3- Règle ~de ~Bayes ~: ~P(w_i | x) = \frac{P(x | w_i)P(w_i)}{\sum_{j=1}^k P(x | w_j)P(w_j)}
\\
On ~choisit ~x ~\epsilon ~w_i ~si ~P(w_i | x) > P(w_j | x) ~pour ~tout ~j ~\epsilon ~k
\\
Llh w_i(x) = \log (2 \pi) - \frac{1}{2} \log \left( \det \Sigma_i \right) - \frac{1}{2} (x - m_i)^T \Sigma_i^{-1} (x - m_i)
\\
g(x) = log(P(x | w_i)P(w_i)) = log(P(x | w_i)) + log(P(w_i))
$

## Moindre carrée :

$
Données ~: (0, 1)(1, 3)(2, 7)
\\
Fonction ~: f(x) = ax + b
\\
Paramètres ~: a, b
\\
1 ~- f ~interpole ~les ~3 ~points ?
\\
f(0) = 1 ~?
\\
f(1) = 3 ~?
\\
f(2) = 7 ~?
\\
2 ~- Version ~analytique ~:
\\
S:(a, b) ~|-> (f(2) - 7)^2 + (f(1) - 3)^2 + (f(0) - 1)^2
\\
CN ~1^{er} ~ordre ~: ~\nabla S(a, b) = \begin{bmatrix} 0 \\ 0 \end{bmatrix}
\\
((u|x)^2) = 2u'(x)u(x)
\\
Montré ~que ~c'est ~un ~min
\\
CS ~2^{ème} ~ordre ~: ~\nabla^2 S(a, b)
\\
3 ~- Version ~factorisé ~:
\\
S(a, b) = T(\beta) = \frac{1}{2}||A\beta - b||^2
\\
avec ~\beta = \begin{bmatrix} a \\ b \end{bmatrix}
\\
déterminer ~A ~et ~b
\\
Résoudre ~\beta = (A^TA)^{-1}A^Tb
$
