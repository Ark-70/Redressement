%%
close all; clear all; clc;
%% TODO
% condition d'arret dès que les classes bougent chacune de moins d'un de
% score

%%

I = imread('implant.bmp');
nb_class = 3;
% imhist(I);
classmask = zeros(size(I));

% Nous on taff sur k-means, avec une variable qui s'update sur la moyenne de la classe en 1D

imshow(I);
[X, Y] = ginput(nb_class);
X = round(X);
Y = round(Y);

% Init les classes par un niveau de gris
grey_levels = zeros(nb_class, 1);
% classes = zeros(nb_class, nb_px)-1;

classes_values = {};
classes_coordx = {};
classes_coordy = {};

for i=1:nb_class

  grey_levels(i) = I(Y(i), X(i)); % On choppe la valeur aux coordonnées comme valeur de niveau de gris moyen de notre classe

  classes_values{i} = [I(Y(i), X(i))];
  classes_coordx{i} = [X(i)];
  classes_coordy{i} = [Y(i)];

  classmask(Y(i), X(i)) = i;

end

L = 5

grey_levels
for i=1:L
    for y=1:size(I, 1)
      for x=1:size(I, 2)

        val = double(I(y, x));
        dist1D = abs(grey_levels-val);
        [~, estimated_class] = min(dist1D);

        % update
        classes_values{estimated_class} = [classes_values{estimated_class} val];
        classes_coordx{estimated_class} = [classes_coordx{estimated_class} x];
        classes_coordy{estimated_class} = [classes_coordy{estimated_class} y];
        grey_levels(estimated_class) = mean(classes_values{estimated_class});    % update grey mean
        classmask(y, x) = estimated_class;

      end
    end

    grey_levels
end
imshow(classmask);
imagesc(classmask);

%% Partie 2, estimation de l'orientation de l'implant

% On suppose la classe 1 l'implant
xmean = mean(classes_coordx{1});
ymean = mean(classes_coordy{1});

% calcul de Cxx
vect_x = classes_coordx{1}; % tous les x
Cxx = mean((vect_x-xmean).^2);

vect_y = classes_coordy{1}; % tous les Y
Cyy = mean((vect_y-ymean).^2);

Cxy = mean((vect_x-xmean).*(vect_y-ymean));

C = [Cxx Cxy;
    Cxy Cyy];

C = C';

[Val, Vect] = eig(C);


