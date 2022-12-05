param fichier := "./archive_1/shift-scheduling.zplread" ;
do print fichier ;


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
var y[Services*Days] >=0;
var z[Services*Days] >=0;
var w[Personnes*Days] binary;

minimize valeur : sum<k> in Personnes: sum<j> in Days: sum<i> in Services: (belowCoverPen[j,i]*z[i,j] + aboveCoverPen[j,i]*y[i,j] + prefOff[k,j,i]*assigned[k,j,i] + prefOn[k,j,i]*(1-assigned[k,j,i]));

subto contrainte : forall<i> in Services: forall<j> in Days: sum<k> in Personnes: (assigned[k,j,i])-y[i,j]+z[i,j] == (requirement[j,i]);

subto unparjour : forall<k> in Personnes: forall<j> in Days: (sum<i> in Services: assigned[k,j,i]) <= 1;

subto dayoff : forall<k> in Personnes: forall<j> in Days: (dayOff[k,j]+sum<i> in Services: (assigned[k,j,i])) <= 1;

subto servmax : forall<k> in Personnes: forall<i> in Services: (sum<j> in Days: assigned[k,j,i]) <= MaxShift[k,i];

subto maxMinutes : forall<k> in Personnes: sum<j> in Days: sum<i> in Services: (assigned[k,j,i]*duree[i]) <= MaxTotalMinutes[k];

subto minMinutes : forall<k> in Personnes: sum<j> in Days: sum<i> in Services: (assigned[k,j,i]*duree[i]) >= MinTotalMinutes[k];

subto travailler: forall<k> in Personnes: forall<j> in Days: sum<i> in Services: assigned[k,j,i] >= w[k,j];

subto travailler2 : forall <k,j> in Personnes*Days : (sum <i> in Services : assigned[k,j,i]) <= (card(Services) * w[k,j]) ;

subto consecutiveshifts : forall <k> in Personnes : forall <d> in Days with d+MaxConsecutiveShifts[k] < horizon : sum <i> in Services : sum <j> in {0 to MaxConsecutiveShifts[k]} with d+j < horizon : (assigned[k,d+j,i]) <= MaxConsecutiveShifts[k];

subto forbidseq : forall<k> in Personnes: forall<j> in {0 to horizon-2}: forall<i1> in Services: forall<i2> in Services: ( ForbiddenSeq [i1,i2] + assigned [k,j,i1] + assigned [k,j+1,i2] ) <= 2;

subto consecutiverepos : forall <k> in Personnes: forall<j> in Days with (2 <= MinConsecutiveDaysOff[k]) and (j+MinConsecutiveDaysOff[k]-1 < horizon) : forall <l> in {2..MinConsecutiveDaysOff[k]} with j+l < horizon : vif w[k,j+1] == 0 and w[k,j] == 1 then w[k,j+l] == 0 end ;

subto consecutivedayshifts : forall<k> in Personnes: forall<j> in {1 to horizon-MinConsecutiveShifts[k]-1} with (2 <= MinConsecutiveShifts[k]): vif w[k,j-1] == 0 and w[k,j] == 1 then sum<d> in {1 to MinConsecutiveShifts[k]-1}: (w[k,j+d]) >= MinConsecutiveShifts[k]-1 end ;
