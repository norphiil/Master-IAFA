% Modelisation du robot SCARA Mitsubishi

%% PARTIE NON MODIFIABLE 
%% INITIALISATION 
%% NE PAS MODIFIER CETTE PARTIE!!!!!!

clc
clear all
close all

% Geometrie du robot
h = 0.8;
L1 = 0.4;
L2 = 0.4;
L3 = 0.2;

% Mesures renvoyees par la camera (position de la piece à saisir dans Rc):
xP = 0.5; yP = 0.2; 

% Differentes configurations de test pour les MGD/MGI
Q1 = zeros(1,4);
Q2 = [pi/2 0 0 0];
Q3 = [0 pi/2 0 0];
Q4 = [0 0 -0.5 pi/2];
Q5 = [pi/2 pi/2 -0.5 0];

% FIN DE LA PARTIE NON MODIFIABLE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choix de la config de test parmi celles definies au-dessus (ou d'autres à votre discretion)
q = Q1;

%% A COMPLETER

%%% SECTION 2.1
	% Utilisation de la fonction drawBM
    drawBM()
	% Calcul du MGD et afficher le repere outil
	% Ne pas oublier hold on si necessaire pour la superposition des courbes


%%% SECTION 2.2

	% Calculer ici TOC la matrice de passage homogene entre R0 et Rc


	% Determination de la situation de la piece dans R0
	% Donnees: position de la piece dans Rc : (xP, yP, h), orientation : cf. Enonce
	% Deduire la situation de la piece dans R0
    % Afficher la position (X,Y,Z) de la piece dans R0 --> Fonction : plot3(X,Y,Z,'ro'); 
  
  	% Calcul du MGI et verification
  	% Affichage






