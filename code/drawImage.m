% Dessine l'évolution des points
% de la cible dans l'image.

function drawImage(X1,Y1,X2,Y2,X3,Y3,X4,Y4)
  figure(1);
  plot(Y1,X1,'b+');
  hold on
  plot(Y2,X2,'r+');
  plot(Y3,X3,'m+');
  plot(Y4,X4,'g+');

