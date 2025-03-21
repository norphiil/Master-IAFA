param fichier := "./archive_1/shift-scheduling.zplread";
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


#################

var assigned[Personnes*Days*Services] binary ;

var work[Personnes*Days] binary;


var y [Days*Services] integer >= 0;
var z [Days*Services] integer >= 0;

# minimize diff : sum<d,s> in Days*Services: y[d,s] + sum<d,s> in Days*Services: z[d,s];

minimize planification : sum <d,s> in Days * Services : (belowCoverPen[d,s] * z[d,s] + aboveCoverPen[d,s] * y[d,s]) + (sum <p,d,s> in Personnes*Days*Services : (prefOff[p,d,s] * assigned[p,d,s] + prefOn[p,d,s] * (1 - assigned[p,d,s]))) ;


subto calculate_gap: forall<d, s> in Days * Services : (sum<p> in Personnes: assigned[p, d, s]) - y[d,s] + z[d,s] == requirement[d, s];


#### Exo 2 ####

# Q2.1
subto one_service_per_day: forall<p, d> in Personnes * Days : (sum<s> in Services: assigned[p, d, s]) <= 1;

# Q2.2
subto daysoff_no_service :forall<p, d> in Personnes * Days : dayOff[p, d] <= 1 - (sum<s> in Services: assigned[p, d, s]);

# Q2.3
subto limit_shifts_per_service: forall<p, s> in Personnes * Services :(sum<d> in Days : assigned[p, d, s]) <= MaxShift[p, s];

# Q2.4
subto total_time_min_per_person:forall<p> in Personnes :MinTotalMinutes[p] <= (sum<d, s> in Days * Services: duree[s] * assigned[p, d, s]);


subto total_time_max_per_person:forall<p> in Personnes :MaxTotalMinutes[p] >= (sum<d, s> in Days * Services: duree[s] * assigned[p, d, s]);



#### Exo 3 ####
# Q3.1
subto work_days_per_person: forall<p, d> in Personnes*Days: sum<s> in Services : assigned[p, d, s] == work[p, d];

subto max_cons_work_days: forall<p> in Personnes: forall<d> in Days with d <= horizon-MaxConsecutiveShifts[p]-1: sum<i> in {d..d+MaxConsecutiveShifts[p]}: work[p, i] <= MaxConsecutiveShifts[p];

# Q3.2
subto forbidden_seq_max: forall<p> in Personnes: forall <s1,s2> in Services*Services with ForbiddenSeq[s1,s2] == 1: forall<d> in Days with d <= horizon-2: assigned[p, d, s1] + assigned[p, d+1, s2] <= 1; 


#### Exo 4 ####



# Q4.1.1
subto min_cons_days_off : forall <p,d> in Personnes * Days with 2 <= MinConsecutiveDaysOff[p] and d + MinConsecutiveDaysOff[p] - 1 < horizon : forall <i> in {2 to MinConsecutiveDaysOff[p] by 1} with d+i < horizon : vif work[p,d] == 1 and work[p,d+1] == 0 then work[p,d+i] == 0 end;


# Q4.1.2
subto min_cons_shifts : forall<p,d> in Personnes * Days with 2 <= MinConsecutiveDaysOff[p] and d + MinConsecutiveDaysOff[p] - 1 < horizon : forall <i> in {2 to MinConsecutiveShifts[p] by 1} with d+i < horizon : vif work[p,d] == 0 and work[p,d+1] == 1 then work[p,d+i] == 1 end;




########### Print ###########
