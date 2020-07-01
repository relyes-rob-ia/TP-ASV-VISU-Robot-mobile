

function [s,z] = visu(OPs, config, Dx, a, b, c, h, r, f)
    % OPs : liste de positions homogenes 4x1 des points de repères par rapport a la scene
    % x, y, r : position de la base mobile M par rapport a l'origine de la scene O
    % a, b, c : position de la camera par rapport à la platine
    % h : hauteur entre la platine et la plateforme
    % f : focale de l'objectif de la camera
    
    PC_RP = [a; b; c];
    OPs_R = OPs;
    MP_RM = [Dx; 0; h];
    OM_R = [config(1); config(2); r];
    theta = config(3);
    qpl = config(4);
    nb_pts = size(OPs, 2);

    % 1) Matrices de passage homogene
    T_R_RM = [
        cos(theta) -sin(theta) 0 OM_R(1);
        sin(theta) cos(theta) 0 OM_R(2);
        0 0 1 OM_R(3);
        0 0 0 1
    ];
    T_RM_RP = [
        cos(qpl) -sin(qpl) 0 MP_RM(1);
        sin(qpl) cos(qpl) 0 MP_RM(2);
        0 0 1 MP_RM(3);
        0 0 0 1
    ];
    T_RP_RC = [
        0 0 1 PC_RP(1);
        0 1 0 PC_RP(2);
        -1 0 0 PC_RP(3);
        0 0 0 1
    ];
    T_R_RC = T_R_RM * T_RM_RP * T_RP_RC;
    T_RC_R = inv(T_R_RC);
    R_RC_R = T_RC_R(1:3,1:3);

    % 2) Calcul des points Pi dans RC
    OC_R = T_R_RC(1:3, 4);
    CPi_RC = zeros(nb_pts, 3);
    for i = 1:nb_pts
        OPi = OPs_R{i}(1:3);
        CPi_R = OPi - OC_R;
        CPi_RC(i,:) = R_RC_R * CPi_R;
    end

    % 3)
    % Projections des points dans le plan image
    Proj = zeros(nb_pts, 2);
    % Hauteurs des points
    z = zeros(nb_pts, 1);
    
    for i = 1:nb_pts
        z(i) = CPi_RC(i, 3);
        Proj(i, 1) = f / z(i) * CPi_RC(i, 1);
        Proj(i, 2) = f / z(i) * CPi_RC(i, 2);
    end
    s = zeros(nb_pts * 2, 1); 
    for i = 1:(nb_pts*2)
        s(i) = Proj(ceil(i/2), mod(i-1,2)+1);
    end
end
