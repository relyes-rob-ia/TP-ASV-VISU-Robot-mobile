

function [qpt] = commande(config, a, b, Dx, nb_pts, s, s_target, z, lambda)
    % config : configuration courante
    % a, b : positions de la camera C par rapport a la platine P
    % Dx : distance entre la base mobile et la platine
    % nb_pts : nb de points de references
    % s : indices visuels courants
    % s_target : indices visuels a atteindre
    % z : vecteur des profondeurs des indices visuels projetes
    % lambda : gain de commande
    
    qpl = config(4);
    J = [
        [-sin(qpl) (a+Dx*cos(qpl)) a];
        [cos(qpl) (-b+Dx*sin(qpl)) -b];
        [0 -1 -1]
    ];

    L = zeros(nb_pts * 2, 3);
    for i = 1:nb_pts
        ind = (i-1)*2+1;
        Xi = s(ind);
        Yi = s(ind+1);
        zi = z(i);
        L(ind,:) = [0 (Xi/zi) (Xi*Yi)];
        L(ind+1,:) = [(-1/zi) (Yi/zi) (1+Yi^2)];
    end
    
    e = s - s_target;
    % L * J * qpt = -lambda * e =>
    qpt = pinv(L * J) * (-lambda * e);
end

