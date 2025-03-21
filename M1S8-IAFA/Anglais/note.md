$$
    Calculer ~z(n) = (y*x)(n) ~avec  ~x(n) = a^nu(n)  ~et  ~y(n) = b^nu(n)  ~et  ~a  ~et  ~b  ~réels  ~et  ~a ≠  ~b
    \\
    z(n) = (y*x)(n)
    \\
    = \Sigma_{k=0}^n y(k) * x(n-k)
    \\
    = \Sigma_{k=0}^n b^(ku) * a^{(n-k)u}
    \\
    = a^nu * \Sigma_{k=0}^n (b/a)^ku
    \\
    = a^nu * (1 - (b/a)^{(n+1)})/(1 - b/a)
$$
