# TD 5

TBOX = {
    ProteinLoverPizza = Pizza $\cap ~\forall$ hasTopping.(Meat $\cap$ Fish), \
    MeatyPizza = Pizza $\cap ~\forall$ hasTopping.Meat,\
    VegetarianPizza = Pizza $\cap ~\forall$ hasTopping.($\neg$ Meat $\cup$ $\neg$ Fish)
}

1. Prouver que les ProteinLoverPizza sont des MeatyPizza

    Il faut donc montrer que ProteinLoverPizza $\subseteq$ MeatyPizza. Il faut donc montrer, en utilisant la TBOC et la ABOX que ProteinLoverPizza $\cup ~\neg$ MeatyPizza n'est pas satisfiable.

    * Normalisation (en NNF) de ProteinLoverPizza $\cap ~\neg$ MeatyPizza

        $\equiv$ Pizza $\cap ~\forall$ hasTopping.(Meat $\cap$ Fish) $\cap$ ( $\neg$ Pizza $\cup ~\exists$ hasTopping. $\neg$ Meat)

    * Construction de l'arbre :

      * 1- Pizza(x) $\cap ~\forall$ hasTopping.(Meat $\cap$ Fish)(x) $\cap$ ( $\neg$ Pizza(x) $\cup ~\exists$ hasTopping. $\neg$ Meat(x))

        * 2- Pizza(x), $\forall$ hasTopping.(Meat $\cap$ Fish)(x), $\neg$ Pizza(x)
          * $\bot$

        * 3- Pizza(x), $\forall$ hasTopping.(Meat $\cap$ Fish)(x), $\exists$ hasTopping. $\neg$ Meat(x)
          * $\bot$

    * Conclusion : Le probleme est insatisfiable, donc les ProteinLoverPizza sont des MeatyPizza

2. On rajoute l'axiome (Propriete par default vrais) Meat $\cap$ Fish $\subseteq ~\bot$ à la TBOX pour indiquer que les classes Meat et Fish sont disjointes. Prouver que ProteinLoverPizza $\subseteq$ VegetarianPizza est maintenant une conséquence logique de la TBOX.

    ProteinLoverPizza $\cup ~\neg$ VegetarianPizza

    TBOX = { \
        ProteinLoverPizza = Pizza $\cap ~\forall$ hasTopping.($\bot$), \
        MeatyPizza = Pizza $\cap ~\forall$ hasTopping.Meat,\
        VegetarianPizza = Pizza $\cap ~\forall$ hasTopping.($\top$) \
    }

    * Normalisation (en NNF) de ProteinLoverPizza $\cap ~\neg$ VegetarianPizza

        $\equiv$ Pizza $\cap ~\forall$ hasTopping.($\bot$) $\cap$ ( $\neg$ Pizza $\cup ~\exists$ hasTopping. $\bot$)

    * Construction de l'arbre :

        * 1- Pizza(x) $\cap ~\forall$ hasTopping.($\bot$)(x) $\cap$ ( $\neg$ Pizza(x) $\cup ~\exists$ hasTopping. $\bot$(x))
          * 2- Pizza(x), $\forall$ hasTopping.($\bot$)(x), $\neg$ Pizza(x)
            * $\bot$
          * 3- Pizza(x), $\forall$ hasTopping.($\bot$)(x), $\exists$ hasTopping. $\bot$(x)
            * $\bot$

    * Conclusion : Lorsqu'on rajoute l'axiome Meat $\cap$ Fish $\subseteq ~\bot$ à la TBOX, le probleme est insatisfiable, donc les ProteinLoverPizza sont des VegetarianPizza (ProteinLoverPizza $\subseteq$ VegetarianPizza)
