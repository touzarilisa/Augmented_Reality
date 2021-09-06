%% Methode DLT 

function[H]=Homographie(m,M)

n=size(m,2);% la taille de n 
A=zeros(2*n,9); 

for i =1:1:n
    
    A(2*i-1,:)=[zeros(1,3),-transpose(M(:,i)),m(2,i)*transpose(M(:,i))];
    A(2*i,:)=[transpose(M(:,i)),zeros(1,3),-m(1,i)*transpose(M(:,i))];
    
end
% on utilise la methode svd pour trouver la solution d'un systeme A*X=0
[u s v]=svd(A);

v=v(:,9);
% on retourne la matrice H 
H=v;
H=transpose(reshape(H,3,3))


