Require Import Lia.

Module INTEGERS.

(* Define the recursive function "pow x n", computing x to the power n *)
Fixpoint pow (x : nat) (n : nat) :=   
  match n with
    0 => 1
  | S p => x * pow x p
  end.

(* We check the type and the result of the evaluation *)
Check pow.

Eval compute in (pow 2 3).

(* Prove that "pow 2 3 = 8" *)
Example pow_2_3 : pow 2 3 = 8.
Proof.
  reflexivity.
Qed.

(* Prove by induction on n the following property.
   We will use the "lia" tactic *)
Lemma pow_1 : forall n, pow 1 n = 1.
Proof.
    induction n.
  - reflexivity.
  - simpl.
    rewrite IHn.
    lia.
Qed.

(* Prove by induction on n the following property.
   We will use the "lia" tactic *)

Lemma pow_add: forall x n m, pow x (n+m) = pow x n * pow x m.
Proof.
  induction n; simpl.
  - intro m.
    lia.
  - intro m.
    rewrite IHn.
    lia.
Qed.

(* Prove by induction on n the following property.
   We will use the "lia" tactic *)

Lemma mul_pow : forall x y n, pow (x*y) n = pow x n * pow y n.
Proof.