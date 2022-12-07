param fichier := "./archive_12/shift-scheduling.zplread";
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

 do print "Services" ;
 do forall <s> in Services do print s, duree[s] ;
 do forall <s1,s2> in Services*Services with ForbiddenSeq[s1,s2] == 1
   do print s1, s2, ForbiddenSeq[s1,s2] ;
 do print "Staff" ; 
 do forall <p> in Personnes
   do print p, MaxTotalMinutes[p], MinTotalMinutes[p],
     MaxConsecutiveShifts[p], MinConsecutiveShifts[p],
     MinConsecutiveDaysOff[p], MaxWeekends[p] ;
 do print "Days Off" ;
 do forall<p,d> in Personnes * Days with dayOff[p,d] == 1 do print p,d,dayOff[p,d] ;
 do print "Pref Shifts On" ;
 do forall<p,d,s> in Personnes * Days * Services
   with prefOn[p,d,s] >= 1 do print p,d,s,prefOn[p,d,s] ;
 do print "Pref Shifts Off" ;
 do forall<p,d,s> in Personnes * Days * Services
   with prefOff[p,d,s] >= 1 do print p,d,s,prefOff[p,d,s] ;
 do print "Cover" ;
 do forall<d,s> in Days * Services
   do print d,s,requirement[d,s], belowCoverPen[d,s], aboveCoverPen[d,s] ;



###########
# Variables

var assigned[Personnes*Days*Services] binary ;
var work[Personnes*Days] binary ;
var y >= 0 ;
var z >= 0 ;

###########
# Objectif

minimize sol : y + z ;
#5
#minimize sol : sum<p, d, s> in Personnes*Days*Services: prefOff[p, d, s]*assigned[p, d, s]+ sum<p, d, s> in Personnes*Days*Services: prefOn[p, d, s]*(1-assigned[p, d, s])+ sum<d, s> in Days*Services: belowCoverPen[d, s]*(y+z)+ sum<d, s> in Days*Services: aboveCoverPen[d, s]*(y+z); 

###########
# Contraintes

subto contrainte_ecart : forall<d,s> in Days*Services : sum<p> in Personnes: assigned[p,d,s] - y + z == requirement[d,s] ;
subto contrainte_travail : forall<p,d> in Personnes*Days : work[p,d] == sum<s> in Services : assigned[p,d,s] ;
#2.1
subto un_service_par_jour : forall<p,d> in Personnes*Days : sum<s> in Services: assigned[p,d,s] <= 1 ;
#2.2
subto day_off : forall<p,d> in Personnes*Days : sum<s> in Services: assigned[p,d,s] + dayOff[p,d] <= 1 ;
#2.3
subto services_max_periode : forall<p,s> in Personnes*Services: sum<d> in Days: assigned[p,d,s] <= MaxShift[p,s] ;
#2.4
subto duree_totale_service_min : forall<p> in Personnes: MinTotalMinutes[p] <= sum<d,s> in Days*Services: duree[s]*assigned[p,d,s] ;
subto duree_totale_service_max : forall<p> in Personnes: MaxTotalMinutes[p] >= sum<d,s> in Days*Services: duree[s]*assigned[p,d,s] ;
#3.1
#subto jours_service_consecutifs : forall<p,d> in Personnes*Days with d <= horizon-1-MaxConsecutiveShifts[p]: MaxConsecutiveShifts[p] >= sum<i> in {d..d+MaxConsecutiveShifts[p]}: work[p, i];
#3.2
#subto forbidden_seq : forall<p,s1,s2> in Personnes*Services*Services with ForbiddenSeq[s1,s2] == 1 : forall<d> in Days with d < horizon-2 : assigned[p,d,s1] + assigned[p,d+1,s2] <= 2;
#4.1.1
#subto jours_min_cons_non_travailles: forall<p> in Personnes: forall<d> in Days with d <= horizon-MinConsecutiveDaysOff[p] and d > 0: vif work[p, d-1] == 1 and work[p, d] == 0 then (sum<i> in {d..(d+MinConsecutiveDaysOff[p]-1)}: work[p, i]) == 0 end;
#4.1.2
#subto jours_min_cons_travail : forall<p> in Personnes:forall<d> in Days with d <= horizon-MinConsecutiveDaysOff[p] and d>0: vif work[p, d-1] == 0 and work[p,d] == 1then sum<i> in {d..(d+MinConsecutiveShifts[p]-1)}: work[p,i] >= MinConsecutiveShifts[p] end;
#subto min_cons_first_work_day : forall<p> in Personnes: vif work[p,0] == 1 then (sum<i> in {0..(MinConsecutiveShifts[p]-1)}: work[p,i]) >= MinConsecutiveShifts[p] end;
#5
subto calc_gap: forall<s,d> in Services*Days : (sum<p> in Personnes: assigned[p, d, s]) - y + z == requirement[d, s];