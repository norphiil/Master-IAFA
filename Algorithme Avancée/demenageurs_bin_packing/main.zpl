param fichier := "./archive_5/bin-packing-difficile-hard.bpa" ;
param C := read fichier as "1n" skip 1 use 1;
param Size := read fichier as "2n" skip 1 use 1;
set Objets := {1 to Size by 1} ;
set Boites := {1 to Size by 1} ;
set tmp[<o> in Objets] := {read fichier as "<1n>" skip 1 + o use 1};
param taille [<o> in Objets] := ord(tmp[o],1,1);
var x[Objets*Boites] binary;
var y[Boites] binary;

minimize y: sum<b> in Boites: y[b];

subto useBoite :
    forall<b> in Boites :
        forall<o> in Objets :
            x[o,b] <= y[b];

subto capaBoite :
    forall<b> in Boites :
        sum<o> in Objets :
            taille[o] * x[o,b] <= C;

subto limAffect :
    forall<o> in Objets :
        sum<b> in Boites :
            x[o,b] == 1;