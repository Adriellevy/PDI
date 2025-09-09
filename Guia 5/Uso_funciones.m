
I = imread('cameraman.tif');
% figure; imshow(I); title('Imagen original');

%% IMTRASLATE
        J = imtranslate(I,[5.3, -10.1],'bicubic' ,'FillValues',115);
        figure, imshow(I);
        figure, imshow(J);
%% IMROTATE
        J = imrotate(I,45,'bicubic');
        figure, imshow(J);
        J = imrotate(J,-45,'bicubic');
        % Crear máscara de píxeles no nulos
        mask = J > 50;

        % Encontrar bounding box de la región válida
        [row, col] = find(mask);
        topRow = min(row); bottomRow = max(row);
        leftCol = min(col); rightCol = max(col);

        % Recortar la imagen filtrando los ceros
        Irec = J(topRow:bottomRow, leftCol:rightCol);
        imshow(Irec); title('Doble rotación filtrando ceros');
%% AFFINED2D + IMWARP
    theta = 10;
    tform = affine2d([cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; 0 0 1]);
    outputImage = imwarp(I,tform);
    figure, imshow(outputImage);
%% IMRESIZE
   B=imresize(I,3);
   imshow(B)
%% IMCROP

%     I2 = imcrop(I,[60 40 100 90]);
%     figure, imshow(I)
%     figure, imshow(I2)  
    
    [X, map] = imread('trees.tif');  % 'trees.tif' viene con MATLAB

    % Mostrar imagen original
    figure; imshow(X, map); title('Imagen original con mapa');

    % Definir rectángulo [x, y, width, height]
    rect = [50 30 100 80];  % crop desde (50,30) con ancho=100 y alto=80

    % Usar imcrop con mapa
    [Y, newmap] = imcrop(X, map, rect);

    % Mostrar resultado
    figure; imshow(Y); title('Imagen recortada con mapa');
%% MESHGRID
% Tamaño de la imagen
[rows, cols] = size(I);

% Crear grilla de coordenadas
[x, y] = meshgrid(1:cols, 1:rows);

% Mostrar qué son x e y
figure;
subplot(1,2,1); imagesc(x); axis image; colorbar; title('Coordenadas X');
subplot(1,2,2); imagesc(y); axis image; colorbar; title('Coordenadas Y');

% Centro de la imagen
cx = cols/2;
cy = rows/2;

% Crear máscara circular con radio 50
radius = 50;
mask = (x-cx).^2 + (y-cy).^2 <= radius^2;

% Aplicar la máscara (circular recorte)
Icircle = uint8(double(I).*mask);

figure;
subplot(1,2,1); imshow(mask); title('Máscara circular');
subplot(1,2,2); imshow(Icircle); title('Imagen filtrada con máscara circular');

