param fichier := "./archive_1/shift-scheduling.zplread" ;
do print fichier ;

### how to run the program
## launch scip.exe
## type in the scip prompt :
#   * read shift-scheduling_lecture-donnees.zpl
#   * optimize
#   * display solution

####################
# Horizon = nb days

param horizon := read fichier as "2n" comment "#" match "^h";
do print "horizon : ", horizon, " jours" ;


############################################
# Sets of days, week-ends, services, staff :

set Days := {0..horizon-1} ;
# All instances start on a Monday
# planning horizon is always a whole number of weeks (h mod 7 = 0)
set WeekEnds := {1..horizon/7} ;
do print card(WeekEnds), " week-ends :" ;
do print WeekEnds ;

set Services := { read fichier as "<2s>" comment "#" match "^d" } ;
do print card(Services), " services" ;

set Personnes := { read fichier as "<2s>" comment "#" match "^s" } ;
do print card(Personnes) , " personnels" ;


############
# Parameters

param duree[Services] := read fichier as "<2s> 3n" comment "#" match "^d";
# do forall <t> in Services  do print "durée ", t, " : ", duree[t] ;

param ForbiddenSeq[Services*Services] :=
	read fichier as "<2s,3s> 4n" comment "#"  match "c" default 0 ;

param MaxTotalMinutes[Personnes] :=
  read fichier as "<2s> 3n" comment "#" match "^s"  ;
param MinTotalMinutes[Personnes] :=
  read fichier as "<2s> 4n" comment "#" match "^s"  ;
param MaxConsecutiveShifts[Personnes] :=
  read fichier as "<2s> 5n" comment "#" match "^s"  ;
param MinConsecutiveShifts[Personnes] :=
  read fichier as "<2s> 6n" comment "#" match "^s"  ;
param MinConsecutiveDaysOff[Personnes] :=
  read fichier as "<2s> 7n" comment "#" match "^s"  ;
param MaxWeekends[Personnes] :=
  read fichier as "<2s> 8n" comment "#" match "^s"  ;

param MaxShift[Personnes*Services] :=
  read fichier as "<2s,3s> 4n" comment "#" match "^m" default 0 ;

param requirement[Days*Services] :=
  read fichier as "<2n,3s> 4n" comment "#" match "^r" ;

param belowCoverPen[Days*Services] :=
  read fichier as "<2n,3s> 5n" comment "#" match "^r" ;

param aboveCoverPen[Days*Services] :=
  read fichier as "<2n,3s> 6n" comment "#" match "^r" ;

param dayOff[Personnes*Days] :=
  read fichier as "<2s,3n> 4n" comment "#" match "^f" default 0 ;

# penalité si jour "pas off" = "on"
param prefOff[Personnes*Days*Services] :=
  read fichier as "<2s,3n,4s> 5n" comment "#" match "^n" default 0 ;

# penalité si jour "pas on" = "off"
param prefOn[Personnes*Days*Services] :=
  read fichier as "<2s,3n,4s> 5n" comment "#" match "^y" default 0 ;

# do print "Services" ;
# do forall <s> in Services do print s, duree[s] ;
# do forall <s1,s2> in Services*Services with ForbiddenSeq[s1,s2] == 1
#   do print s1, s2, ForbiddenSeq[s1,s2] ;
# do print "Staff" ;
# do forall <p> in Personnes
#   do print p, MaxTotalMinutes[p], MinTotalMinutes[p],
#     MaxConsecutiveShifts[p], MinConsecutiveShifts[p],
#     MinConsecutiveDaysOff[p], MaxWeekends[p] ;
# do print "Days Off" ;
# do forall<p,d> in Personnes * Days with dayOff[p,d] == 1 do print p,d,dayOff[p,d] ;
# do print "Pref Shifts On" ;
# do forall<p,d,s> in Personnes * Days * Services
#   with prefOn[p,d,s] >= 1 do print p,d,s,prefOn[p,d,s] ;
# do print "Pref Shifts Off" ;
# do forall<p,d,s> in Personnes * Days * Services
#   with prefOff[p,d,s] >= 1 do print p,d,s,prefOff[p,d,s] ;
# do print "Cover" ;
# do forall<d,s> in Days * Services
#   do print d,s,requirement[d,s], belowCoverPen[d,s], aboveCoverPen[d,s] ;



###########
# Variables
# var x = personnes assignées :
var assigned[Personnes*Days*Services] binary ;
var y[Days*Services] integer >=0;
var z[Days*Services] integer >=0;
# var n = personnes requises

#minimize objectif: sum <d> in Days : sum <s> in Services : (y[d,s] + z[d,s]);

# minimize obj :
#   (sum <d,s> in Days*Services : (belowCoverPen[d,s] * z[d,s] + aboveCoverPen[d,s] * y[d,s]) )
#   + ( sum <p,d,s> in Personnes*Days*Services : (prefOff[p,d,s] * assigned[p,d,s] + prefOn[p,d,s] * (1-assigned[p,d,s])) ) ;
# 


# Exercice 1 :
#minimiser la somme des écarts entre les nbs de personnes requises, chaque jour et pour chaque service,
#et les nbs de personnes affectées chaque jour à chaque service (x - y + z = n)
subto cont1 : forall <d> in Days : forall <s> in Services : sum <p> in Personnes : assigned[p,d,s] - y[d,s]+z[d,s] == requirement[d,s];
# La valeur de l'objectif pour la solution optimale est : 0 (car on a pas mis de contraintes)


# Exercice 2 :
#personne ne peut faire plus d'un service/jour
subto cont21 : forall <p> in Personnes : forall <d> in Days : sum <s> in Services : assigned[p,d,s] <= 1;
#pour chaque personne p et chaque jour d, si dayOff[p, d] = 1 alors p ne doit être affectée à
#aucun service ce jour-là
subto cont22 : forall <p> in Personnes : forall <d> in Days : forall <s> in Services : assigned[p,d,s] <= (1 - dayOff[p,d]);
#chaque personne p ne peut prendre plus de MaxShift [p, s] fois le service s sur la période
subto cont23 : forall <p> in Personnes : forall <s> in Services : sum <d> in Days : assigned[p,d,s] <= MaxShift[p,s];
#la durée totale de service (en minutes) de la personne p doit être dans l’intervalle
#[MinTotalMinutes [p], MaxTotalMinutes[p]]
subto cont241 : forall <p> in Personnes : sum <d> in Days : (sum <s> in Services : (assigned[p,d,s] * duree[s])) >= MinTotalMinutes[p];
subto cont242 : forall <p> in Personnes : sum <d> in Days : (sum <s> in Services : (assigned[p,d,s] * duree[s])) <= MaxTotalMinutes[p];


# Exercice 3 :
#à aucun moment durant la période, le nombre. de jours de service consécutifs pour la personne p
#ne dépasse MaxConsecutiveShifts [p]
subto cont31 : forall <p> in Personnes : forall <d> in Days with d + MaxConsecutiveShifts[p] < horizon : sum <s> in Services : (sum <d> in Days : assigned[p,d,s]) <= MaxConsecutiveShifts[p];
#si p effectue le service s 1 un certain jour d, et si ForbiddenSeq [s1 , s2] = 1, alors p ne doit pas
#faire le service s 2 le jour d + 1
subto cont32 : forall <p> in Personnes : forall <d> in Days with d +1 < horizon : forall <s1> in Services : forall <s2> in Services : ForbiddenSeq[s1,s2] * (assigned[p,d,s1]+assigned[p,d+1,s2]) <= 1;


# Exercice 4 :
#C’est plus facile de travailler avec, pour chaque personne p et chaque jour d, une
#variable booléenne w pd qui vaudra 1 si p travaille le jour d, 0 sinon, c’est-à-dire que w pd = 1
#quand assigned [p, d, s] vaut 1 pour au moins l’un des services s
var w[Personnes*Days] binary ;
#contrainte w : w pd ≤ assigne [p, d, E] + assigne [p, d, D] + assigne [p, d, L] ≤ 3 × w pd
subto contw1 : forall <p> in Personnes : forall <d> in Days : w[p,d] <= (sum <s> in Services : assigned[p,d,s]);
subto contw2 : forall <p> in Personnes : forall <d> in Days : (sum <s> in Services : assigned[p,d,s]) <= card(Services) * w[p,d];
#contrainte w : w pd = assigned [p, d, E] + assigned [p, d, D] + assigned [p, d, L]
#contrainte qui remplace les 2 au-dessus
#subto contsub : forall <p> in Personnes : forall <d> in Days : (sum <s> in Services : assigned[p,d,s]) == w[p,d];

#à aucun moment durant la période il y a une séquence de jours non travaillés par p qui fait
#moins de MinConsecutiveDaysOff[p] jours
subto cont411 : forall <p> in Personnes : forall <d> in Days with (d+MinConsecutiveDaysOff[p]-1) < horizon : forall <j> in {2..MinConsecutiveDaysOff[p]} with d+j < horizon :
vif (w[p,d+1] == 0 and w[p,d] == 1)
	then w[p,d+j] == 0 end;
#à aucun moment durant la période, le nombre de jours de service consécutifs pour la personne p
#n'est inférieur à MinConsecutiveShifts[p]
subto cont412 : forall <p> in Personnes : forall <d> in Days with (d+MinConsecutiveDaysOff[p]-1) < horizon : forall <j> in {2..MinConsecutiveShifts[p]} with d+j < horizon :
vif (w[p,d+1] == 1 and w[p,d] == 0)
	then w[p,d+j] == 1 end;


#-------------------------------------------------------------------------

#subto c11_exo4 :
#  forall <p,d> in Personnes*Days
#  with (2 <= MinConsecutiveDaysOff[p]) and (d+MinConsecutiveDaysOff[p]-1 < horizon) :
#  forall <j> in {2..MinConsecutiveDaysOff[p]} with d+j < horizon :
#  vif w[p,d+1] == 0 and w[p,d] == 1 then w[p,d+j] == 0 end ;

#subto c12_exo4 :
#  forall <p,d> in Personnes*Days
#  with (2 <= MinConsecutiveShifts[p]) and (d+MinConsecutiveShifts[p]-1 < horizon) :
#  forall <j> in {2..MinConsecutiveShifts[p]} with d+j < horizon :
#  vif w[p,d+1] == 1 and w[p,d] == 0 then w[p,d+j] == 1 end ;



#-------------------------------------------------------------------------



# Exercice 5 :
#Modifier l’objectif pour que, au lieu de minimiser simplement l’écart entre les nombres de personnes
#requises et les nombres de personnes affectées à chaque service, on minimise la somme de toutes
#ces pénalités
# NE PAS OUBLIER DE METTRE L'OBJECTIF PLUS HAUT EN COMMENTAIRE
minimize objectif : sum <p> in Personnes : (
sum <d> in Days : (
sum <s> in Services : (
(prefOff[p,d,s] * w[p,d]) + (prefOn[p,d,s] * (1-w[p,d]))))) +
(sum <d> in Days : sum <s> in Services :
(belowCoverPen[d,s] * z[d,s]
+ (aboveCoverPen[d,s] * y[d,s])) );
