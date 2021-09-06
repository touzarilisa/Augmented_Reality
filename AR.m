%% PROGRAMME REALITE AUGMENTEE
clear all
close all
clc
%%
% Creation du cube virtuel
for i=1:25
  M_virtuels(1,i)=i;
  M_virtuels(2,i)=0;
  M_virtuels(3,i)=0;
  M_virtuels(4,i)=1;
end
for i=26:50
  M_virtuels(1,i)=0;
  M_virtuels(2,i)=(i-25);
  M_virtuels(3,i)=0;
  M_virtuels(4,i)=1;
end
for i=51:75
  M_virtuels(1,i)=25;
  M_virtuels(2,i)=(i-50);
  M_virtuels(3,i)=0;
  M_virtuels(4,i)=1;
end
for i=76:100
  M_virtuels(1,i)=(i-75);
  M_virtuels(2,i)=25;
  M_virtuels(3,i)=0;
  M_virtuels(4,i)=1;
end
for i=101:125
  M_virtuels(1,i)=i-100;
  M_virtuels(2,i)=0;
  M_virtuels(3,i)=75;
  M_virtuels(4,i)=1;
end
for i=126:150
  M_virtuels(1,i)=0;
  M_virtuels(2,i)=(i-125);
  M_virtuels(3,i)=75;
  M_virtuels(4,i)=1;
end
for i=151:175
  M_virtuels(1,i)=25;
  M_virtuels(2,i)=(i-150);
  M_virtuels(3,i)=75;
  M_virtuels(4,i)=1;
end
for i=176:200
  M_virtuels(1,i)=(i-175);
  M_virtuels(2,i)=25;
  M_virtuels(3,i)=75;
  M_virtuels(4,i)=1;
end
for i=201:275
  M_virtuels(1,i)=0;
  M_virtuels(2,i)=0;
  M_virtuels(3,i)=i-200;
  M_virtuels(4,i)=1;
end
for i=276:350
  M_virtuels(1,i)=0;
  M_virtuels(2,i)=25;
  M_virtuels(3,i)=i-275;
  M_virtuels(4,i)=1;
end
for i=351:425
  M_virtuels(1,i)=25;
  M_virtuels(2,i)=0;
  M_virtuels(3,i)=i-350;
  M_virtuels(4,i)=1;
end
for i=426:500
  M_virtuels(1,i)=25;
  M_virtuels(2,i)=25;
  M_virtuels(3,i)=i-425;
  M_virtuels(4,i)=1;
end
%%
%%Lecture de la video et Frames
videoReader = VideoReader('VideoInitiale.MOV'); % lecture de la video 
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520]);%
objectFrame = readFrame(videoReader);% lecture de la 1 ere frame 
figure; imshow(objectFrame);

% les coordonnées de nos 4 points de la 1 ére frame                                            
points=[681,440;1029,518;469,691;864,798]; % les coordonnées de nos 4 point
%utilisation du tracker pour trouver les pts dans les autres frames
tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points,objectFrame);%initializer le tracker

i=1;
img=1; % l'indice des frames 
M=[0 100 0 100;0 0 100 100;1 1 1 1];% les Points Monde

while hasFrame(videoReader)
    
      frame = readFrame(videoReader); %lire la frame
      [points,validity] = tracker(frame); %tracker les pts
      
      frames=strcat('frame',num2str(img),'.jpg');% Ouvrire la frame       
      imwrite(frame,frames);% sauvegarder la frame

      % calcul des matrices Homographie
      points = points';
      points(3,:) = ones(1,4);
      H = Homographie(points,M);
      
      %calcule des pts images grace a la matrice Projection
      m_virtuels=P(H,img)*M_virtuels;
      
      % Normalisation des pts m
      for i=1:length(M_virtuels) 
          m_virtuels(:,i)=m_virtuels(:,i)/m_virtuels(3,i);
      end
      
      m_virtuels = m_virtuels';
      % Ecrire les points sur la frame img
      I = imread(frames);
      tm_test=insertMarker(I,m_virtuels(:,1:2),'o','Color','magenta','size',10);
      frames=strcat('newframe',num2str(img),'.jpg');      
      imwrite(tm_test,frames) % pour sauvegarder la nouvelle frame
      
      img=img+1;
      
end
release(videoPlayer);

%%
%Creaction de la nouvelle video
video = VideoWriter('VdieoAR.avi'); % cree l'objet video
open(video); % ouvrir le fichier video
for ii=1:img-1 % le nombre de frame
  I = imread("newframe"+ii+".jpg"); % lire l'image suivante
  writeVideo(video,I); % ecrire l'image dans video
end
close(video); % fermer le fichier
%%
% Supression des frames
for ii=1:img-1 % le nombre de frame
  delete("frame"+ii+".jpg"); % lire l'image suivante
end
for ii=1:img-1 % le nombre de frame
  delete("newframe"+ii+".jpg"); % lire l'image suivante
end

