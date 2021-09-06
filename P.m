%% Matrice de Projection a partir de l'Homographie

function [P]=P(H,img)

K=[3339,0,0;0,3337,0;2002,1448,1];% matrice intrinseque
K=K';
L=inv(K)*H;
L=[L(:,1) L(:,2) cross(L(:,1),L(:,2))];
% choix de alpha 
if img<80 
    alpha=-(det(L))^(1/4);
else
    alpha=(det(L))^(1/4);
end
x=(inv(K)*H)/alpha;
P=K*[x(:,1), x(:,2) ,cross(x(:,1),x(:,2)),x(:,3)];% la matrice P
    
end
