

clear;

% --- Initialisations
disp('Initialisations...');
OPs = {[8; 2.2; 1; 1] [8; 1.8; 1; 1] [8; 1.8; 0.6; 1] [8; 2.2; 0.6; 1]};
nb_pts = size(OPs, 2);
Dx = 0.1;
a = 0; b = 0; c = 0;
h = 0.4;
r = 0.4;
Te = 10^-3;
f = 1;
% Un gain trop eleve semble faire accelerer le robot, et il semble qu'il puisse depasser l'objectif en allant trop vite et il n'arrive pas a converger
% Un gain trop faible empechera le robot d'atteindre son objectif
lambda = 0.25;

s = zeros(nb_pts * 2, 1);
s_target = [-0.2; 0.2; -0.2; -0.2; 0.2; -0.2; 0.2; 0.2];

% --- Configurations Q disponibles pour les tests
% [x, y, theta, qpl]

% Q0: A l'objectif
Q0 = [6.9, 2, 0, 0];
% Q1: Va a l'objectif 
Q1 = [0, 2, 0, 0];
% Q2: Va a l'objectif par une courbe
Q2 = [0, 0, 0, pi/6];
% Q3: Se tourne vers l'objectif (pour le voir il faut plot les premieres iterations du robot) et va a l'objectif par une courbe
Q3 = [2, 0, -2*pi/3, 5*pi/6];
config = Q3;

% --- Algorithme principal
i = 0;
convergence = false;
epsi = 10^-1;
nb_it_max = 10000;
    
figure(1);
drawRobotPlatine(config(1), config(2), config(3), config(4)); 

disp('Simulation en cours...');
while not(convergence) && i < nb_it_max
    [s, z] = visu(OPs, config, Dx, a, b, c, h, r, f);
    qpt = commande(config, a, b, Dx, nb_pts, s, s_target, z, lambda);
    [config] = etat(config, qpt, Te);
    
    if mod(i, 200) == 0
        % Draw le robot toutes les 200 iterations pour eviter de trop ralentir la simulation
        drawRobotPlatine(config(1), config(2), config(3), config(4)); 
    end
    
    % On arrete quand on a atteint le point a epsi pres.
    diff = sum(abs(s - s_target));
    convergence = (diff <= epsi);
    i = i + 1;
end

drawTarget(OPs{1}, OPs{2}, OPs{3}, OPs{4});
drawRobotPlatine(config(1), config(2), config(3), config(4)); 
fprintf('Termine (diff avec l''objectif = %f, iterations = %d)', diff, i);

%drawImage(s(1), s(2), s(3), s(4), s(5), s(6), s(7), s(8));
