(* Rappel syntaxe Coq : les commentaires s'écrivent entre (* et *). *)

(******************************)
(* Tutoriel (Cours/TP) de Coq *)
(******************************)

(* Voir aussi ces supports de Cours (UE TAPFA, L3 Info, UPS) :

   https://pfitaxel.github.io/tapfa-coq-alectryon/

   Seule la lecture des 2 premiers Cours (pas le 3e) serait utile pour TL
 *)

(* Ce tutoriel se présente sous la forme d'un fichier .v à compléter.

   Vous pouvez coder vos réponses :
   - dans JsCoq (éditeur en ligne, pratique mais pas suffisant pour TPs TL :
     https://jscoq.github.io/scratchpad.html )

   - dans Emacs+ProofGeneral (environnement de TP recommandé :
     https://github.com/erikmd/tapfa-init.el )
 *)

(* N'hésitez pas à solliciter votre encadrant pour toute question. *)

(* Pour évaluer les phrases dans l'éditeur en ligne JsCoq,
   utiliser les trois boutons adéquats (ou Alt+N, Alt+P, Alt+Entrée)

   Pour évaluer les phrases dans Emacs+ProofGeneral :
   - aller jusqu'au curseur en faisant "C-c RET" (<=> Ctrl+C Entrée)
     ou "C-c C-RET"
   - avancer/reculer d'un cran avec "C-c C-n" et "C-c C-u"
   - et pour aller à la fin de la zone validée, faire "C-c C-."
 *)

(*********************************************************)
(* D'abord un petit peu de programmation (fonctionnelle) *)
(*********************************************************)

(* Définissons la fonction qui à n, associe n + 1. *)

(* En OCaml, on aurait écrit :

   let f = fun n -> n + 1;;
 *)

(* En Coq, on écrit : *)

Definition f := fun n => n + 1.

(* En maths, on écrirait :

   f : N ⟶ N
       n ↦ n+1

   "↦" ("\mapsto" en LaTeX) s'écrira "fun … => …" en Coq.

   La partie "N ⟶ N" existe aussi en Coq et est appelée «type» de la fonction.

   Ici Coq l'a automatiquement inféré, on peut l'afficher avec : *)

Check f.

(* On aurait aussi pu le donner explicitement *)
Definition f2 : nat -> nat := fun n => n + 1.

(* Contrairement à OCaml, il est impossible de définir en Coq deux
   fonctions (ou types) ayant le même nom dans le même fichier ;
   ainsi, cela permet d'éviter des confusions. *)
Fail Definition f2 := fun n => n + 2.
(* La commande "Fail" vérifie que la phrase qui suit donne une erreur,
   ignore celle-ci et permet de continuer tout de même.
   Cette commande a donc essentiellement un but de «documentation». *)

(* De manière générale, "t : T" se lit «t est de type T».
   On peut mettre de telles «annotations de type» un peu partout et
   t n'est pas nécessairement une fonction. *)
Definition f3 := fun (n : nat) => n + 1.

(* Autre syntaxe : pour éviter d'avoir à écrire fun, on peut également
   écrire le nom de l'argument après celui de la fonction, avant ":="
   (et c'est dorénavant ce que l'on fera). *)
Definition f4 n := n + 1.

(* La syntaxe change mais c'est exactement la même fonction, comme la
   montre la commande Print. *)
Print f4.
Print f.  (* même résultat *)

(* Comme avec tout langage de programmation, on peut évaluer les fonctions *)
Eval compute in f 2.
(* Tout comme en OCaml, on pourrait écrire "f(2)", mais les parenthèses
   ne servent à rien s'il n'y a pas de sous-expression à regrouper ;
   on utilise donc généralement simplement un espace : "f 2" *)

(* On peut aussi demander le type de f 2 *)
Check f 2.
(* Bien sûr, il faut que le terme soit bien typé. Ceci échoue : *)
(* Check f f. *)
(* Commentez la ligne précédente (ou ajoutez la commande "Fail" devant)
pour pouvoir continuer *)

(****************************************************)
(* Petit rappel sur les fonctions d'ordre supérieur *)
(****************************************************)

(* Comme en OCaml, on peut définir des fonctions curryfiées
(c.-à-d. prenant deux arguments ou plus) : *)
Definition g x y := x + 2 * y.

(* syntaxes équivalentes *)
Definition g2 := fun x y => x + 2 * y.
Definition g3 := fun x => (fun y => x + 2 * y).

(* Regardons le type de g *)
Check g.
(* on obtient «nat -> nat -> nat» qui se lit «nat -> (nat -> nat)»
   c.-à-d. la fonction g est une fonction à un argument (x), qui
   renvoie une fonction prenant un argument (y) et retournant x+2y. *)
Check g 1.

(* pour l'évaluation, on peut donc écrire *)
Eval compute in (g 1) 3.
(* ou plus simplement *)
Eval compute in g 1 3.

(* On peut aussi définir des fonctionnelles, c.-à-d. des fonctions
prenant des fonctions en argument : *)
Definition repeat_twice f (x : nat) := f (f x).

Check repeat_twice.
(* repeat_twice *)
(*      : (nat -> nat) -> nat -> nat *)

Print f.
Eval compute in repeat_twice f 2.

(******************************************************************)
(* Encore un peu de programmation, quelques structures de données *)
(******************************************************************)

(* un des types les plus simples : les booléens *)
Check true.
Check false.

(* Les booléens sont définis dans la bibliothèque standard de Coq
comme un type utilisateur à 2 constructeurs :

un booléen est soit true, soit false (et rien d'autre) *)
Print bool.

(* true et false sont ainsi des constructeurs. Notez au passage qu'il
n'y a pas de contrainte sur la «casse» des constructeurs dans Coq :
pas besoin qu'ils commencent par une majuscule. *)

(* on peut examiner la valeur d'un booléen avec un match *)

Definition et a b :=
  match a with
  | true => b
  | false => false
  end.

(* L'écriture "if b then ct else cf" est juste du sucre syntaxique
pour le match ci-dessus et c'est l'écriture simplifiée par défaut : *)

Print et.

(* Mais on peut passer en mode "affichage bas-niveau" pour désactiver
cette écriture simplifiée : *)

Set Printing All.

Print et.

Unset Printing All.

Eval compute in et true false.

Eval compute in et true true.

(* (* Similairement à OCaml, on est obligé de définir tous les cas, mais
   le «filtrage non-exhaustif» est une erreur, pas un warning
   (commenter pour pouvoir continuer) *)
Definition et_non_exhaustif a b :=
  match a with
  | true => b
  end. *)

(* La bibliothèque standard de Coq fournit des notations "&&", "||"
associée aux définitions "andb" (identique à notre définition "et"
donc dans la suite on utilisera donc "andb" plutôt que "et"), "orb",
et "negb" : *)

Check andb false true.
Check orb false true.
Check negb false.
Eval compute in negb false.

(* Une invocation possible pour avoir des notations plus légères : *)
Open Scope bool_scope.

Check andb false true.
Check orb false true.

(* un type un peu plus complexe : les entiers naturels.

Ils sont définis dans la bibliothèque standard de Coq comme un type
utilisateur à 2 constructeurs :

un entier est soit O, soit le successeur d'un entier. *)
Print nat.

(* Notez que la syntaxe affichée par Coq est équivalente à la syntaxe
suivante, vue en cours :

Inductive nat :=
  | O
  | S (_ : nat). *)

(* Au moment où ce type nat est défini dans la bibliothèque standard,
   Coq génère automatiquement le principe d'induction "nat_ind", qui
   coïncide naturellement avec le schéma de "preuve par récurrence",
   que l'on (re)verra plus loin. *)
Check nat_ind.

(* À noter, la représentation des entiers sous cette forme correspond
   à une "représentation en base 1", c'est-à-dire que le nombre entier
   16, même si Coq le "lit" et "l'écrit" en base 10 avec les options
   d'affichage par défaut, en interne, il est stocké sous la forme
   d'une expression inductive impliquant 17 constructeurs ! *)

Set Printing All.
Check 16.
Unset Printing All.
Check 17.

(* Bien entendu, d'autres représentations plus compactes des entiers
   naturels (en binaire…) et des entiers relatifs, sont disponibles
   dans la bibliothèque standard de Coq, mais nous n'approfondirons
   pas cet aspect durant ce TP ni dans l'UE TL. *)

(* Nous avons rappelé précédemment (fonction "et") la syntaxe de Coq
   pour effectuer un filtrage (syntaxe très proche de celle d'OCaml !)

   Quant à l'équivalent du "let rec" en Coq, il s'agit d'utiliser
   la commande "Fixpoint".
   En revanche, nous n'utiliserons pas l'équivalent Coq de la syntaxe
   "let rec … in", puisqu'en pratique cela rendrait plus compliqué les
   preuves de propriétés de la fonction définie localement... *)

(* Définir la fonction "factorielle" de type "nat -> nat".
   Puis calculer "factorielle 3".

   Rappel sur la récursion : il faut que vous veilliez à ce que vos
   définitions de fonctions récursives aient des appels récursifs dont
   l'argument principal soit décroissant structurellement (pour
   garantir la terminaison. Sinon, Coq refusera votre définition ! *)


Fixpoint factorielle n :=
   match n with
      | 0 => 1
      | S m => n * (factorielle m)
   end.


Fixpoint fib n :=
   match n with
      0 => 0
      | 1 => 1
      | S m => fib m + match m with S p => fib p | _ => 1 end
   end.


Eval compute in fib 10.


(* Définir le prédicat booléen "pair" de type "nat -> bool".
   Puis calculer "pair 6". *)

Fixpoint pair n :=  
   match n with 
      0 => true
      | 1 => false
      | S (S m) => pair (m - 2)
   end.

Fixpoint pair2 n :=  
   match n with 
      0 => true
      | S m => negb (pair2 m)
   end.

Eval compute in pair2 3.


(* Pour conclure sur cette revue du filtrage et de la récursion en Coq
   voici un exemple de définition d'un prédicat booléen "inf",
   testant si un entier n est plus petit ou égal à un autre entier m.
   Pouvez-vous expliquer avec vos propres mots chacune des branches du
   match ? (qui correspond ici à un filtrage simultané !) *)
Fixpoint inf n m :=
  match n,m with
  | O, _ => true
  | S n1, O => false
  | S n1, S m1 => inf n1 m1
  end.
Check inf.
Eval compute in inf 2 3.
Eval compute in inf 1 0.

(* Remarque : ne pas confondre les opérations booléennes «calculables»
&&, || et negb, avec les connecteurs logiques /\, \/ et ~, qui ne
prennent pas en argument des booléens mais des Propositions : *)

Check 0 = 0.
(* 0 = 0 *)
(*      : Prop *)

Check (0 = 0) /\ (0 = 0).

Check 0 < 1 \/ 0 = 1 \/ 0 > 1.

(* "/\" est ainsi une notation pour and,
   "\/" pour or,
   "~" pour not *)

Check and (0 = 0) (0 = 0).
Check or (0 < 1) (or (0 = 1) (0 > 1)).

(* Q1. Qu'est-ce qu'une proposition dans Coq ?
   Q2. comment montrer qu'une proposition est vraie ?

Avant de faire des exercices spécifiques pour prouver des propositions
simples de 3 façons différentes (à la main, de façon semi-automatique
ou complètement automatique), deux réponses rapides :


R1. Une proposition est une formule logique, et dans Coq c'est à la
fois un objet de type Prop, et un type de données dont les expressions
de ce type sont les preuves de la formule en question.

Cela correspond à la notion de «correspondance de Curry-Howard» vue en
cours.

Par exemple, on aura  (preuve que 0=0) : 0 = 0 : Prop

Ainsi, Prop est un "type de type", au même titre que le mot-clé Type
vu en cours.

Il y a quelques différences de sémantique entre Prop et Type que nous
ne détaillerons pas ici. (La principale idée étant que Type correspond
au type des «types de données informatifs» (entiers,listes,fonctions),
Prop correspond au type des «formules purement logiques».)


R2. Pour montrer qu'une proposition P est vraie, il s'agit d'exhiber
une preuve, c'est-à-dire une expression p qui a le bon type (p : P).

Le but de l'assistant de preuves Coq est de faciliter la construction
de ces termes de preuve (p), puis au moment du "Qed.", de vérifier
automatiquement que le type du terme de preuve coïncide avec l'énoncé
de la formule que l'on veut prouver.

Maintenant, des exercices. *)

(**************************************************************)
(* Premières preuves "à la main", en logique propositionnelle *)
(**************************************************************)
(* 
Section PremieresPreuves.

(* Dans cette section, supposons trois propositions A, B et C *)
Variables A B C : Prop.

(* une fonction est une preuve : par exemple, la fonction identité
   "prouve" que A implique A *)
Definition identite : A -> A := fun a => a.

(* prouver au moins 2 propriétés parmi les propriétés suivantes *)


Definition ex0 : B -> B := fun b => b.

Definition ex1 : A -> B -> A := fun a b => a.

Definition ex2 : A -> B -> B := fun a b => b.

Definition ex3 : A -> (A -> B) -> B := fun a f => f a.

Definition ex4 : (A -> B) -> (B -> C) -> A -> C := fun f g a => g (f a).

Definition ex5 : (A -> B) -> (A -> B -> C) -> A -> C := fun f g a => g a (f a). *)


(**************************)
(*                        *)
(* PARTIE PREUVE ASSISTÉE *)
(*                        *)
(**************************)

(******************************************)
(* Retour sur la logique propositionnelle *)
(******************************************)

Section PremieresTactiques.

(* Dans cette section, supposons trois propositions A, B et C *)
Variables A B C : Prop.

(* On pourrait faire toutes nos preuves en écrivant des fonctions du
   bon type, comme précédemment, mais ça devient vite inhumain ; Coq
   propose donc un mode interactif dans lequel il va nous aider à
   construire les preuves étape par étape (d'où le nom d'assistant de
   preuve). *)

Lemma ex0 : B -> B.
(* au lieu de Lemma, on pourrait utiliser les synonymes Theorem,
Remark, Corollary, Fact, Example *)
Proof.
(* on démarre une preuve interactive *)
(* on tape maintenant des tactiques qui vont modifier les sous buts à
prouver jusqu'à ce qu'il n'en reste plus *)
intros Hb.
(* notre première tactique, on bouge l'hypothèse B et on lui donne le nom Hb *)
(* Hb a pour type B cad que Hb est une preuve de B *)
apply Hb.
(* notre deuxième tactique, on utilise B *)
Qed.
(* Quod Erat Demonstrandum, CQFD en latin, on enregistre et vérifie la preuve *)

(* en fait, ici Coq sait se débrouiller tout seul *)
Lemma ex0' : B -> B.
Proof. auto. Qed.

(* refaire les preuves précédentes en utilisant les tactiques intros et apply *)
Lemma ex1 : A -> B -> A.
Proof.
   intros Ha Hb.
   apply Ha.
Qed.

Lemma ex2 : A -> B -> B.
Proof.
   intros Ha Hb.
   apply Hb.
Qed.

(*
  Pour ex3, on remarquera que le type de la 2eme hypothese introduite est
  un type fonctionnel. Il est donc possible d'appliquer la fonction sur un
  argument de type A pour obtenir un B.
  En déduire 2 preuves différentes de ex3', en utilisant la tactique apply
  une seule fois ou bien deux fois.
  On notera (Print ex3_Vi) que le terme construit est le même.
*)
Lemma ex3_V1 : A -> (A -> B) -> B.
Proof.
   intros H1 H2.
   apply H2 in H1.
   apply H1.
Qed.

Lemma ex3_V2 : A -> (A -> B) -> B.
Proof.
(* ... (à compléter) *)
Admitted.

Lemma ex4 : (A -> B) -> (B -> C) -> A -> C.
Proof.
(* ... (à compléter) *)
Admitted.

Lemma ex5b : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
   intros f g a.
   apply g.
   - apply a.
   - apply f.
      apply a.
Qed.

(* en présence de plusieurs sous-buts, on peut utiliser des accolades
   pour les délimiter *)
Lemma ex5' : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
intros Hab Habc Ha.
apply Habc.
{ admit. (* ... (à compléter) *)
}
admit. (* ... (à compléter) *)
Admitted.

(* ou délimiter les sous-buts avec des items "-" *)
Lemma ex5'' : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
intros Hab Habc Ha.
apply Habc.
- admit. (* ... (à compléter) *)
- admit.  (* ... (à compléter) *)
Admitted.

(* remarque: ces lemmes sont assez simples et la tactique «auto» les
   prouve tous *)
Lemma ex5''' : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
auto.
Qed.

(* Considérons la conjonction de 2 propositions : A /\ B.
   À partir de A et de B, on peut prouver A /\ B en appliquant conj.
   À ne pas confondre avec la fonction (andb : bool -> bool -> bool).
*)
Check conj.

Lemma ex6 : A -> B -> A /\ B.
Proof.
intros Ha Hb.
apply conj.
- apply Ha.
- apply Hb.
Qed.

(* la tactique «split» est un synonyme de «apply conj» *)
Lemma ex6' : A -> B -> A /\ B.
Proof.
intros Ha Hb.
split. (* 2 sous-buts sont produits: prouver A, prouver B *)
- apply Ha. (* 1er sous-but: on prouve A *)
- apply Hb. (* 2eme sous-but: on prouve B *)
Qed.

(* on peut détruire A /\ B après l'avoir introduit, avec "destruct …"
ou "destruct … as [Ha Hb]" *)
Lemma ex7 : A /\ B -> A.
intros Hab. (* Hab est une preuve de A/\B *)
destruct Hab as [Ha Hb]. (* Ha est une preuve de A, Hb une preuve de B *)
apply Ha.
Qed.

(* Prouver le lemme suivant *)
(* Lemma ex8 : A /\ B -> B /\ A.
Proof.
 intro Hab.
 destruct Hab.
 split.
 - apply Ha
 - apply H
Qed. *)

(* la disjonction (ou) est similaire : A \/ B.
   À partir de A (resp. B), on a une preuve de A \/ B.
   Si on a une preuve de A ou une preuve de B,
   on peut prouver A \/ B en appliquant or_introl (resp. or_intror) *)
Check or_introl.
Check or_intror.

Lemma ex9 : A -> A \/ B.
Proof.
intros Ha.
apply or_introl.
apply Ha.
Qed.

(* la tactique «left» (resp. right) est un synonyme de «apply or_introl» *)
Lemma ex9' : A -> A \/ B.
Proof.
intros Ha.
left.
apply Ha.
Qed.

(* de même que A /\ B, on peut détruire A \/ B avec "destruct …" ou
   "destruct … as [Ha | Hb]"
 *)
(* on notera que la destruction d'un ET produit 2 hypothèses alors que
   la destruction d'un OU conduit à réaliser 2 preuves - 1 pour chaque hypothèse
 *)
Lemma ex10 : A \/ B -> (B -> A) -> A.
Proof.
intros Hab.
destruct Hab as [Ha | Hb]. (* crée 2 sous-buts *)
- intros _. (* on n'a pas besoin de l'hypothèse introduite, donc on l'ignore avec _ *)
apply Ha.
- intros Himpl.
apply Himpl.
apply Hb.
Qed.

(* Prouver le lemme suivant *)
Lemma ex11 : A \/ B -> B \/ A.
Proof.
(* ... (à compléter) *)
Admitted.

End PremieresTactiques.

(***************************************************)
(* Calcul des prédicats (avec des quantificateurs) *)
(***************************************************)
Section CalculPredicats.

Variable P Q : nat -> Prop.
Variable R : nat -> nat -> Prop.

(* Prouver *)
Lemma ex12 : (forall x, P x) /\ (forall x, Q x) -> (forall x, P x /\ Q x).
Proof. (* on pourra utiliser «intros x» et apply *)
   intro H.
   intro.
   destruct H.
   split.
   - apply (H x).
   - apply H0.
Qed.

(* Prouver *)
Lemma ex13 : (forall x, P x) \/ (forall x, Q x) -> (forall x, P x \/ Q x).
Proof.
   firstorder.
Qed.

(* Essayez de prouver (si c'est possible !) *)
Lemma ex14 : (forall x, P x \/ Q x) -> (forall x, P x) \/ (forall x, Q x).
Proof.
(* ... (à compléter) *)
Abort.

(* (H : exists x, …) se détruit avec "destruct H as [x Hx]" *)
(* et se prouve avec la tactique «exists x» : pour prouver une formule
  exists x, P x, il faut fournir une valeur pour x et prouver qu'elle
  satisfait P *)
Lemma ex15 : (exists x, forall y, R x y) -> (forall y, exists x, R x y).
Proof.
intros Hex.
destruct Hex as [x Hx].
intros y.
exists x.
apply Hx.
Qed.

(* Prouver *)
Lemma ex16 : (exists x, P x -> Q x) -> (forall x, P x) -> exists x, Q x.
Proof.
(* ... (à compléter) *)
Admitted.

End CalculPredicats.

(**************************************)
(* Retour aux booléens et aux entiers *)
(**************************************)

Open Scope bool_scope.

(* les booléens permettent de faire facilement des preuves par "force brute"
(énumération de tous les cas) : *)
Lemma negneg : forall b, negb (negb b) = b.
Proof.
intros b.
destruct b. (* génère un but pour chaque valeur possible de b *)
- easy. (* un peu plus puissant que "reflexivity" *)
- easy.
Qed.

(* Prouver *)
Lemma and_commutatif : forall a b, a && b = b && a.
Proof.
(* ... (à compléter) *)
Admitted.

(* on considère l'addition sur les entiers définie dans la librairie Coq par :

Fixpoint plus n m :=
  match n with
  | 0 => m
  | S p => S (plus p m)
  end.

On notera donc que
  - (plus 0 m) se réduit en m
  - (plus (S n) m) se réduit en S (plus n m).
Par contre (plus n 0) ne se réduit pas.
 *)

(* la tactique «simpl» permet de simplifier des termes *)
Lemma plus0n : forall n, plus 0 n = n.
Proof.
intros n.
simpl.
reflexivity.
Qed.

(* mais on peut aussi écrire directement *)
Lemma plus0n' : forall n, plus 0 n = n.
Proof.
reflexivity. (* puisque les 2 termes sont identiques après réduction *)
Qed.

(* ça ne marche pas dans l'autre sens *)
Lemma plusn0 : forall n, plus n 0 = n.
Proof.
intros n.
simpl. (* ne fait rien *)
(* en effet, plus est défini récursivement sur son premier argument,
ici il s'agit de n qui est un entier naturel quelconque (on ne sait
pas s'il est de la forme O ou S n') donc on ne peut rien calculer *)
Abort.

(* On va donc procéder par récurrence sur n on utilise pour cela la
   tactique induction *)
Lemma plusn0 : forall n, plus n 0 = n.
Proof.
(* pas besoin de faire "intros n" avant ! *)
induction n.
- (* simpl. inutile *) reflexivity. (* cas de base *)
- simpl. (* utile pour faire apparaitre le terme de gauche de l'égalité *)
  rewrite IHn. (* hypothèse de récurrence *)
  (* on peut utiliser rewrite avec n'importe quelle égalité *)
  (* si besoin on pourrait utiliser l'égalité de droite à gauche en faisant
     rewrite <-IHn *)
  easy.
Qed.

(* Prouver *)
Lemma plus1n : forall n, plus 1 n = S n.
Proof.
(* ... (à compléter) *)
Admitted.

(* Prouver *)
Lemma plusSn : forall n m, S (plus n m) = plus n (S m).
Proof.
(* ... (à compléter) *)
Admitted.

(* Prouver (un peu plus dur, ne pas hésiter à utiliser les lemmes précédents)  *)
Lemma plus_commutatif : forall n m, plus n m = plus m n.
Proof.
(* ... (à compléter) *)
Admitted.

(* on peut aussi utiliser les opérateurs +,* qui ne sont que des notations *)
Lemma plus_commutatif_bis : forall n m, n + m = m + n.
Proof.
apply plus_commutatif.
Qed.

From Coq Require Import Lia. (* Linear Integer Aritmetic :
preuve automatique de propriétés linéaires sur les entiers *)

Lemma plus_commutatif' : forall n m, n + m = m + n.
Proof.
intros n m.
lia. (* c'est automatique! *)
Qed.
(* lia supporte la somme, le produit par une constante, les comparaisons *)

(*****************************)
(* Preuve en avant, Coupures *)
(*****************************)

(* Jusqu'à maintenant, les preuves ont été réalisées en modifiant le
but jusqu'à le rendre trivial ou le ramener à un lemme connu.

On fait souvent l'inverse quand on rédige une preuve sur papier : on
part des hypothèses et on les modifie pour atteindre la conclusion.
On parle de style de preuve «en avant».

Cela consiste souvent à faire ce qu'on appelle une coupure : on met la
preuve «en pause» pour prouver un résultat intermédiaire qui sera
ensuite utilisé.

On peut pour cela faire un lemme intermédiaire (comme le lemme "plusSn"
dans la preuve de "plus_commutatif" plus haut) mais ça impose parfois
de recopier toutes les hypothèses et de laisser traîner un lemme
peut-être trop spécialisé pour être réellement réutilisable.

La tactique
«assert (nom : propriété).» fournit une alternative plus légère. *)

Lemma plus_commutatif'' : forall n m, plus n m = plus m n.
Proof.
induction n.
- intros m.
  rewrite plusn0.
  easy.
- assert (HplusSn : forall m, S (plus m n) = plus m (S n)).
  { induction m.
    - easy.
    - simpl.
      rewrite IHm.
      easy.
  } (* on a maintenant HplusSn dans nos hypothèses *)
  intros m.
  simpl.
  rewrite IHn.
  rewrite HplusSn.
  easy.
Qed.

(**************************)
(* Preuves sur les listes *)
(**************************)

Require Import List.
Import ListNotations.
(* les 2 constructeurs sont notés [] et _::_ comme en Caml *)

(* À mettre au début du fichier ou avant la 1ère définition polymorphe *)
Set Implicit Arguments.

Fixpoint append T (l1 l2 : list T) : list T := (* T rendu implicite *)
  match l1 with
    [] => l2
  | x :: r => x :: append r l2 (* le 1er argument T est implicite *)
  end.
Eval compute in append [1;2] [3;4].  (* utilise "append", défini précédemment *)
Eval compute in [1;2] ++ [3;4].  (* utilise "app" de la bibliothèque standard *)
(* la concaténation est ainsi est notée "… @ …" en Caml, "… ++ …" en Coq *)

(* Le principe d'induction sur les listes est automatiquement généré lors
   de la définition du type list. L'itérateur le plus général sur les listes
   a pour type le principe d'induction : *)
Check list_ind.

(* Prouvons un lemme de correction de la fonction "app" *)

Lemma app_length :
  forall T (l l' : list T), length (app l l') = length l + length l'.
Proof.
(* ... (à compléter, en commençant par induction l) *)
Admitted.

Print app_length. (* noter que le lambda-terme de preuve contient "list_ind" *)
