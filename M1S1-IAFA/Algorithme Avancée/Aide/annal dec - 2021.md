# EMINF1C1 - Algorithmique Avancée - Contrôle Terminal

Exercice 1 (CSP, 6 points). On considère cinq variables A; B; C ; D; E, ayant toutes le même domaine : \
DA = DB = DC = DD = DE = {1; 2; 3; 4; 5}, et les contraintes suivantes : \
 A > B, B > C , B > E, C != D, C != E, |A − D| >= 3.

Question 1.1. Montrez qu'en appliquant la propagation de contraintes on arrive aux domaines réduits suivants :

| DA   | DB      | DC      | DD   | DE      |
| ---- | ------- | ------- | ---- | ------- |
| 4, 5 | 2, 3, 4 | 1, 2, 3 | 1, 2 | 1, 2, 3 |
