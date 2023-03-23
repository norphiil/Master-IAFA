# TD 2

## Exercice 2

### Cyclistes et musiciens (sémantique)

On considère maintenant l'ensemble d'assertions A = { musicien(Mike), musicien(Léo), cycliste(Hugo), connaît(Mike, Léo), connaît(Léo, Hugo), voisinDe(Mike, Tom), voisinDe(Mike, Léo), voisinDe (Tom, Hugo) }. Cet ensemble définit une interprétation I pour les concept musicien, cycliste et les rôles connaît et voisinDe (connaît(x,y) signifie que x connaît y ; voisinDe(x,y) signifie que x est voisin de y) sur le domaine ∆I = { Mike, Léo, Tom, Hugo }.

$\Delta^I$ = { Mike, Léo, Tom, Hugo } \
musicien = { Mike, Léo } \
cycliste = { Hugo } \
connait = { (Mike, Léo), (Léo, Hugo) } \
voisin = { (Mike, Tom), (Mike, Léo), (Tom, Hugo) }

À l'aide des concepts déjà introduits, donner la description d'un concept correspondant aux classes suivantes :

1. Les musiciens qui connaissent quelqu'un qui connaît un cycliste

    musicien $\cap ~\exists$ connait. $\exists$ connait. cycliste

    {Léo, Mike} $\cap ~\exists$ connait {Léo}
    {Léo, Mike} $\cap$ {Mike}
    {Mike}

2. Les cyclistes qui ne connaissent que ceux qui connaissent un cycliste

    cycliste $\cap ~\forall$ connait. $\exists$ connait. cycliste

    {Mike} $\cap ~\forall$ connait {Léo}
    {Mike} $\cap$ {Mike, Tom, Hugo} $\cap$ {Mike, Léo}
    {}

3. Les musiciens qui sont voisins de quelqu'un qui connaît un cycliste

    musicien $\cap ~\exists$ voisin. $\exists$ connait. cycliste

    {Léo, Mike} $\cap ~\exists$ voisin {Léo}
    {Léo, Mike} $\cap$ {Mike}
    {Mike}

4. Ceux qui ne sont pas musiciens et qui sont connus par quelqu'un qui n'est pas un cycliste

    $\neg$ musicien $\cap ~\exists$ connait-. $\neg$ cycliste

    {Hugo, Tom} $\cap ~\exists$ connait- {Mike, Léo, Tom}
    {Hugo, Tom} $\cap$ {Léo, Tom}
    {Hugo}

## Exercice 3 : énoncé

### Les vacances (exercice récapitulatif)

Pour les vacances il y a plusieurs lieux de séjours possibles : la mer, la montagne ou la campagne. On peut y pratiquer différentes activités : les sports nautiques, les sports de glace, ou encore les sports de raquette. Les personnes peuvent réserver un séjour dans ces différents lieux qui proposent ces différentes activités.

1. À partir de ces connaissances exprimées en langage naturel et dans le cadre de la logique de description, déterminer, sans rajouter de connaissances superflues la TBOX càd les connaissances génériques sur les classes d'objets (concepts, arité 1) et leurs relations (rôles, arité 2), ainsi que les éventuels objets.

   * Les concepts personne qui définit la classe des personnes (personne(x) signifie que x est une personne) et lieuSéjour qui définit la classe des lieux de séjours (lieuSéjour(x) signifie que x est un séjour) ... mer, montagne, campagne, activité, sportNautique, sportGlace, sportRaquette

   * Les rôles :
     * pratique qui définit la relation entre une personne et une activité (pratique(x,y) signifie que la personne x pratique l'activité y)

     * réserve qui définit la relation entre une personne et un lieu de séjour (réservé(x,y) signifie que la personne x réserve l'activité y)

     * propose qui définit la relation entre un lieu de séjour et une activité (proposé(x,y) signifie que le lieu x propose l'activité y)

    Pour la TBOX, on ajoute les relations d'inclusion entre ces classes :
    * Mer $\subseteq$ lieuSéjour
    * etc...

2. Dessiner la hiérarchie des classes

    ```mermaid

    graph TD;
        Personne

        lieuSéjour --> Mer
        lieuSéjour --> Montagne
        lieuSéjour --> Campagne

        activité --> SportNautique
        activité --> SportGlace
        activité --> SportRaquette
    ```

3. Donner la description des concepts représentant les classes suivantes :
   1. Les personnes qui pratiquent au moins une activité

        personne $\cap ~\exists$ pratique. activité

   2. Les personnes qui pratiquent un sport nautique et un sport de raquette

        personne $\cap ~\exists$ pratique. sportNautique $\cap ~\exists$ pratique. sportRaquette

   3. Les lieux de séjour qui ne proposent que des sports de glace

        lieuSéjour $\cap ~\exists$ propose $\cap ~\forall$ propose. sportGlace

   4. Les activités qui sont proposées par un séjour à la campagne ou à la mer

        activité $\cap$ ($~\exists$ propose$-$. campagne $\cup ~\exists$ propose$-$. mer)

   5. Les personnes qui pratiquent une activité qui est proposée par un séjour à la mer

        personne $\cap ~\exists$ pratique. (activité $\cap ~\exists$ propose$-$. mer)

4. Compléter la TBOX pour exprimer les contraintes suivantes :
   * Un sport de glace n'est proposé que par un séjour à la montagne

        sportGlace $\subseteq \forall$ propose$-$. montagne \
        ou encore \
        $\exists$ propose. sportGlace $\cap$ montagne

   * Toute personne pratiquant un sport nautique réserve un séjour à la mer

        $\exists$ pratique. sportNautique $\subseteq ~\exists$ réservé. mer

5. On considère maintenant la ABOX constituée par l'ensemble d'assertions suivant qui définit un modèle partiel I de la TBOX sur le domaine $\Delta^I$ = { Anne, Arthur, Fred, Louise, Patinage, Plongée, Tennis, Voile, Chamonix, Morzine, Nice }.

    ABOX = { Personne(Anne), Personne(Arthur), Personne(Fred), Personne(Louise), Mer(Nice), Montagne(Chamonix), Montagne(Morzine), SportNautique(Voile), SportNautique(Plongée), SportGlace(Patinage), SportRaquette(Tennis), pratique(Arthur, Plongée), pratique(Fred, Patinage), pratique(Louise, Tennis), pratique(Louise, Voile), propose(Nice, Plongée), propose(Nice, Voile), propose(Chamonix, Patinage), propose(Chamonix, Tennis), propose(Morzine, Patinage), réserve(Fred, Chamonix), réserve(Louise, Nice) }.

    $\Delta^I$ = { Anne, Arthur, Fred, Louise, Patinage, Plongée, Tennis, Voile, Chamonix, Morzine, Nice } \
    Propose = { (Nice, Plongée), (Nice, Voile), (Chamonix, Patinage), (Chamonix, Tennis), (Morzine, Patinage) } \
    Réserve = { (Fred, Chamonix), (Louise, Nice) } \
    Pratique = { (Arthur, Plongée), (Fred, Patinage), (Louise, Tennis), (Louise, Voile) }

   * Interpréter dans $I$ chacun des cinq concepts précédents

     1. Les personnes qui pratiquent au moins une activité

        personne $\cap ~\exists$ pratique. activité \
        personne $\cap$ {Arthur, Fred, Louise}

     2. Les personnes qui pratiquent un sport nautique et un sport de raquette

        personne $\cap ~\exists$ pratique. sportNautique $\cap ~\exists$ pratique. sportRaquette \
        personne $\cap$ {Louise}

     3. Les lieux de séjour qui ne proposent que des sports de glace

        lieuSéjour $\cap ~\exists$ propose $\cap ~\forall$ propose. sportGlace \
        lieuSéjour $\cap$ {Morzine}

     4. Les activités qui sont proposées par un séjour à la campagne ou à la mer

        activité $\cap$ ($~\exists$ propose$-$. campagne $\cup ~\exists$ propose$-$. mer) \
        activité $\cap$ {Plongée, Voile}

     5. Les personnes qui pratiquent une activité qui est proposée par un séjour à la mer

        personne $\cap ~\exists$ pratique. (activité $\cap ~\exists$ propose$-$. mer) \
        personne $\cap$ {Arthur, Louise}


   * Interpréter dans $I$ le concept ci-dessous en donnant d'abord sa définition en langage naturel :

        LieuSéjour $\cap ~\exists$ réserve$-$. (Personne $\cap \forall$ pratique. (SportGlace $\cup$ SportNautique) $\cap ~\exists$ pratique)

        Les lieux de séjour qui ont été réservés par une personne qui pratique un sport de glace ou un sport nautique

        = {Chamonix}
