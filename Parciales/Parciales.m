%%Transformacion Isometrica

I = imread('cameraman.tif'); % cualquier imagen
% imgTrans=TransformacionIsometrica(I, 45, 0.5, 0.5, 100, 100, 'forward');

%% Transformada de fourrier + Filtro PB o PA
I = im2double(I);

% Tamaño de la imagen
[M, N] = size(I);

% FFT de la imagen
F = fftshift(fft2(I));

% Crear máscara circular (filtro pasa-bajos ideal)
Filtro = circulo_centrado(N,M,25);

% Aplicar máscara al espectro
F_filt = F .* Filtro;

% Transformada inversa
I_filt = real(ifft2(ifftshift(F_filt)));

% Mostrar resultados
figure;
subplot(2,2,1);
imshow(I, []);
title('Imagen original');

subplot(2,2,2);
imshow(log(1+abs(F)), []);
title('Espectro original');

subplot(2,2,3);
imshow(Filtro, []);
title('Máscara circular');

subplot(2,2,4);
imshow(I_filt, []);
title('Imagen filtrada (pasa-bajos)');    
%% Utilizando la imagen Camera man y M,N calculados previamente (tamaño img)
%Filtro Notch sin mucho exito porque tengo que eliminar lineas en camaraman
u0 = 183;   % frecuencia en x (ajustar según el espectro)
v0 = 76;  % frecuencia en y (ajustar según el espectro)
r  = 10;  % radio del notch
filtro_NTCH = filtro_notch(M,N,u0,v0,5);
F_filtrado = F .* filtro_NTCH;
I_filtrada = real(ifft2(ifftshift(F_filtrado)));
figure;
subplot(2,2,1), imshow(I, []), title('Imagen original');
subplot(2,2,2), imshow(log(1+abs(F)), []), title('Espectro original');
subplot(2,2,3), imshow(filtro_NTCH, []), title('Filtro notch');
subplot(2,2,4), imshow(I_filtrada, []), title('Imagen filtrada');
%% Intento filtro via lineas (bastante desente)
I = im2double(imread('cameraman.tif'));
[M,N] = size(I);
F = fftshift(fft2(I));

% Crear filtro para eliminar líneas en 0° y 90°
H = filtro_lineas(M,N,[90],4); % 5 grados de ancho

% Aplicar
F_filtrado = F .* H;
I_filtrada = real(ifft2(ifftshift(F_filtrado)));

% Mostrar
figure;
subplot(1,3,1), imshow(log(1+abs(F)),[]), title('Espectro original');
subplot(1,3,2), imshow(H,[]), title('Máscara angular');
subplot(1,3,3), imshow(I_filtrada,[]), title('Imagen filtrada');
%% Operaciones morfologicas
%% Script: Morphological_Operations.m
% Ejemplo de operaciones morfologicas sobre la imagen circles.png

clc; clear; close all;
% 1. Cargar la imagen
I = imread('circles.png');   % Imagen binaria
figure; imshow(I); title('Imagen original');

% 2. Definir elementos estructurantes
SE_square = strel('square', 15);   % Elemento estructurante cuadrado (15x15)
SE_disk   = strel('disk', 10);     % Elemento estructurante circular (radio=10)

% Puedes elegir uno u otro para aplicar:
SE = SE_disk; % <-- cambia a SE_square si quieres probar con cuadrado

% 3. Aplicar operaciones morfológicas
I_dilate  = imdilate(I, SE);
I_erode   = imerode(I, SE);
I_open    = imopen(I, SE);
I_close   = imclose(I, SE);

% 4. Mostrar resultados
figure;

subplot(2,3,1);
imshow(I); title('Original');

subplot(2,3,2);
imshow(I_dilate); title('Dilatación');

subplot(2,3,3);
imshow(I_erode); title('Erosión');

subplot(2,3,4);
imshow(I_open); title('Apertura');

subplot(2,3,5);
imshow(I_close); title('Cierre');

sgtitle('Operaciones Morfologicas con Structuring Element');

%% Pre procesado de la imagen binarizada
I = dicomread('Corte.dcm');
BW1_Preprocesada=imopen(I, SE);
imshow(BW1_Preprocesada,[])
%% Binarizacion de una imagen dicom
% Leer la imagen DICOM

W = 89;  % ancho de ventana
C = 964;   % centro de ventana

% Binarización normal
BW1_contours = dicomBinarize(BW1_Preprocesada, W, C, 0);
figure; imshow(BW1); title('Binarización normal');

%% Quedarme solo con los bordes de la imagen binarizada
BW_edges1 = filtro_bordes(BW1_contours, 'morph', 3);
BW_edges2 = filtro_bordes(BW1_contours, 'canny', 3);

figure;
subplot(1,3,1); imshow(I); title('Original');
subplot(1,3,2); imshow(BW_edges1); title('Bordes morfológicos');
subplot(1,3,3); imshow(BW_edges2); title('Bordes Canny');

%% Hough circules

[centers, radii] = houghCircles(BW_edges2, [15 30], 1);

figure; imshow(BW1,[]); hold on;
viscircles(centers, radii, 'EdgeColor','g');
title('Círculos detectados con Hough');


