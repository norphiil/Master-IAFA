param fichier := "./shift-scheduling-5.zplread" ;
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

var assigned[Personnes*Days*Services] binary ;
var y[Days*Services] >= 0 ;
var z[Days*Services] >= 0 ;

minimize valeur: sum<d,s> in Days*Services: (y[d,s] + z[d,s]) ;
subto q1 :
  forall<d, s> in Days*Services :
    (sum <p> in Personnes :  assigned[p, d, s]) + y[d, s] -z[d, s] == requirement[d, s];

subto q2_1 :
  forall<p, d> in Personnes*Days :
    (sum <s> in Services :  assigned[p, d, s]) <= 1;

subto q2_2 :
  forall<p, d> in Personnes*Days :
    if dayOff[p, d] == 1 then
      (sum <s> in Services :  assigned[p, d, s]) == 0
    end;

subto q2_3 :
  forall<p, s> in Personnes*Services :
    (sum <d> in Days :  assigned[p, d, s]) <= MaxShift[p, s];

subto q2_4_1:
  forall <p> in Personnes:
    (sum <s> in Services : sum <d> in Days : assigned[p,d,s]*duree[s]) <= MaxTotalMinutes[p];

subto q2_4_2:
  forall <p> in Personnes:
    (sum <s> in Services : sum <d> in Days : assigned[p,d,s]*duree[s]) >= MinTotalMinutes[p];

subto q3_1:
  forall <p> in Personnes:
    forall <d> in Days with d<(horizon-MaxConsecutiveShifts[p]) :
      (sum <j> in { d..d+MaxConsecutiveShifts[p]} : sum <s> in Services : assigned[p,j,s]) <= MaxConsecutiveShifts[p];

subto q3_2:
   forall <d> in Days with d<horizon-1:
      forall <p> in Personnes:
        forall <s1> in Services:
          forall <s2> in Services:
            (2-ForbiddenSeq[s1,s2]-assigned[p,d,s1]) >= assigned[p,d+1,s2];


# Exprimer des contraintes conditionnelles pour que :
# 1. à aucun moment durant la période il y ait une séquence de jours non travaillés par p qui fasse moins de MinConsecutiveDaysOff[p] jours ;
# 2. à aucun moment durant la période, le nombre. de jours de service consécutifs pour la personne p ne soit inférieur à MinConsecutiveShifts[p].
# Indication 1 : Pour contraindre qu'il n'y ait pas par exemple de séquence de repos de moins de 3 jours qui commence un certain jour d, on peut écrire vif assigned [p ,d -1 , s ] == 1 and assigned [p ,d , s ] == 0 then assigned [p , d +1 , s ] + assigned [p , d +2 , s ] == 0 end ;
# Indication 2 : C'est plus facile de travailler avec, pour chaque personne p et chaque jour d, une variable booléenne wpd qui vaudra 1 si p travaille le jour d, 0 sinon, c'est-à-dire que wpd = 1 quand assigned[p; d; s] vaut 1 pour au moins l'un des services s. S'il y a trois services, on peut modéliser cela avec la double contrainte : wpd ≤ assigne[p; d; E] + assigne[p; d; D] + assigne[p; d; L] ≤ 3 * wpd or, de manière équivalente puisqu'on sait que personne ne peut effectuer plus d'un service par jour :
# wpd = assigned[p; d; E] + assigned[p; d; D] + assigned[p; d; L]

subto q4_1:
  forall <p> in Personnes:
    forall <d> in Days with d<(horizon-MinConsecutiveDaysOff[p]) :
      (sum <j> in { d..d+MinConsecutiveDaysOff[p]} : sum <s> in Services : assigned[p,j,s]) >= MinConsecutiveDaysOff[p];

# On observe que les contraintes conditionnelles précédentes génèrent beaucoup de
# nouvelles variables et de contraintes conditionnelles. Réexprimer directement les contraintes
# ci-dessus à l'aide de contraintes linéaires, en observant par exemple que si, pour p, le nombre
# minimum de jours consécutifs travaillés est 3, alors il suffit d'interdire les séquences de la forme
# Off - On - Off, Off - On - On - Off.
subto q4_2:
  forall <p> in Personnes:
    forall <d> in Days with d<horizon-1:
      forall <s1> in Services:
        forall <s2> in Services:
          (2-ForbiddenSeq[s1,s2]-assigned[p,d,s1]) >= assigned[p,d+1,s2];
# subto q4_2:
#   forall <p> in Personnes:
#     forall <d> in Days with d<(horizon-MinConsecutiveShifts[p]) :
#       (sum <j> in { d..d+MinConsecutiveShifts[p]} : sum <s> in Services : assigned[p,j,s]) >= MinConsecutiveShifts[p];

# Les instances ont aussi des paramètres qui pondèrent les écarts, en terme de nombre de personnels, par rapport aux nombres requis pour chaque service ; ainsi que des paramètres qui permettent de prendre en compte certaines préférences des personnels.
subto q5_1:
  forall <d,s> in Days*Services:
    sum <p> in Personnes : assigned[p,d,s] <= requirement[d,s] + aboveCoverPen[d,s] ;
