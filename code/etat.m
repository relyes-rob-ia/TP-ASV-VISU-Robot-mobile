
function [next_config] = etat(config, qpt, Te)
    % config : configuration courante
    % qpt : commande generee
    % Te : periode d'echantillonnage
  
    v = qpt(1);
    w = qpt(2);
    wpl = qpt(3);
    
    next_config = config;
    next_config(1) = config(1) + Te * v * cos(config(3));
    next_config(2) = config(2) + Te * v * sin(config(3));
    next_config(3) = config(3) + Te * w;
    next_config(4) = config(4) + Te * wpl;
end
