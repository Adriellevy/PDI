%% GUIA 5 - Procesamiento Digital de Imágenes
% Este script acompaña los ejercicios de la guía
% Cada sección tiene ejemplos y llama funciones auxiliares

clc; clear; close all;

%% =========================
% 1. TRANSFORMACIONES ISOMÉTRICAS
% =========================

I = imread('cameraman.tif');
figure; imshow(I); title('Imagen original');

%% -------------------------------
% a.i) Traslación con imtranslate
% -------------------------------
% Sintaxis: J = imtranslate(I, [dx, dy], 'FillValues', valor, 'OutputView', tipo)
% 'OutputView' puede ser:
%   - 'same': mantiene el tamaño original
%   - 'full': agranda el lienzo para mostrar todo
dx = 50; dy = 30;
J_same = imtranslate(I, [dx dy], 'OutputView', 'same'); 
J_full = imtranslate(I, [dx dy], 'OutputView', 'full');

figure;
subplot(1,2,1); imshow(J_same); title('Traslación (OutputView = same)');
subplot(1,2,2); imshow(J_full); title('Traslación (OutputView = full)');

disp('-> Con "same" se conserva tamaño. Con "full" se expande el lienzo');

%% -------------------------------
% a.ii) Traslación circular
% -------------------------------
% Se implementa con circshift
J_circ = circularShift(I, [0 50]); % 50 píxeles a la derecha
figure;
subplot(1,2,1); imshow(I); title('Original');
subplot(1,2,2); imshow(J_circ); title('Traslación circular (50 px derecha)');

%% -------------------------------
% b.i) Rotación con imrotate
% -------------------------------
% Sintaxis: J = imrotate(I, angulo, metodo, 'crop'/'loose')
% Métodos: 'nearest', 'bilinear', 'bicubic'

J_near = imrotate(I, 45, 'nearest', 'crop');
J_bilin = imrotate(I, 45, 'bilinear', 'crop');
J_bicub = imrotate(I, 45, 'bicubic', 'crop');

figure;
subplot(1,3,1); imshow(J_near); title('Rotación 45° - Nearest');
subplot(1,3,2); imshow(J_bilin); title('Rotación 45° - Bilinear');
subplot(1,3,3); imshow(J_bicub); title('Rotación 45° - Bicubic');

disp('-> Con crop se conserva tamaño, con loose se expande la imagen');

%% -------------------------------
% b.ii) Rotar 45° y luego -45° (sin crop)
% -------------------------------
J_45 = imrotate(I, 45, 'bilinear', 'loose');
J_back = imrotate(J_45, -45, 'bilinear', 'loose');

figure;
subplot(1,3,1); imshow(I); title('Original');
subplot(1,3,2); imshow(J_45); title('Rotada 45° (loose)');
subplot(1,3,3); imshow(J_back); title('Rotada 45° y luego -45°');

disp(['Tamaño original: ' mat2str(size(I))]);
disp(['Tamaño después de 45°: ' mat2str(size(J_45))]);
disp(['Tamaño después de rotar -45°: ' mat2str(size(J_back))]);

%% -------------------------------
% b.iii) Rotaciones sucesivas de 1°
% -------------------------------
J_loop = I;
for k = 1:360
    J_loop = imrotate(J_loop, 1, 'bilinear', 'crop');
    % para ver el efecto animado, descomentar:
    % imshow(J_loop); title(['Iteración ' num2str(k)]);
    % pause(0.01);
end

figure;
subplot(1,2,1); imshow(I); title('Original');
subplot(1,2,2); imshow(J_loop); title('Tras 360 rotaciones de 1° (bilinear)');

disp('-> Comparar con una única rotación de 360°');
J_once = imrotate(I, 360, 'bilinear', 'crop');
figure;
subplot(1,2,1); imshow(J_once); title('Rotación única de 360°');
subplot(1,2,2); imshow(J_loop); title('Rotaciones sucesivas de 1°');

%% -------------------------------
% b.iv) Rotación desde centro arbitrario
% -------------------------------
cx = size(I,2)/3; % un centro arbitrario
cy = size(I,1)/2;
J_arbitrary = RotateAround(I, 30, cx, cy);

figure;
imshow(J_arbitrary); title('Rotación 30° desde centro arbitrario');


%% =========================
% 2. TRANSFORMACIONES SEMEJANTES
% =========================

% Escalado básico
I_scaled = imresize(I, 0.5, 'nearest');
figure; imshow(I_scaled); title('Escalado 0.5 - Nearest');

% Escalado desde centro
I_scaled_center = scaleFromCenter(I, 1.5, 'bilinear');
figure; imshow(I_scaled_center); title('Escalado desde centro (1.5x)');

%% =========================
% 3. TRANSFORMACIONES AFINES
% =========================

tform = affine2d([1 0.3 0; 0 1 0; 0 0 1]); % Cizallamiento horizontal
I_shear = imwarp(I, tform);
figure; imshow(I_shear); title('Cizallamiento horizontal');

%% =========================
% 4. TRANSFORMACIONES PROYECTIVAS
% =========================

%% -------------------------------
% a) Uso de projective2d
% -------------------------------
I = imread('cameraman.tif');

% Definimos una matriz de transformación proyectiva
% Matriz general 3x3 (homogénea)
% [a b c; d e f; g h 1]
T = [1 0.2 0;   % inclinación horizontal
     0.3 1 0;   % inclinación vertical
     0.001 0.001 1]; % términos proyectivos

tform = projective2d(T);
J = imwarp(I, tform);

figure;
subplot(1,2,1); imshow(I); title('Imagen original');
subplot(1,2,2); imshow(J); title('Transformación projective2d');

disp('Ventaja de projective2d: permite deformaciones de perspectiva (proyectivas),');
disp('no solo cizallamientos/rotaciones/escalados como affine2d.');

%% -------------------------------
% b) Uso de matchFeatures
% -------------------------------
% Usamos un ejemplo con imágenes distintas
I1 = rgb2gray(imread('peppers.png'));
I2 = imresize(I1, 0.7); % la segunda imagen es escalada y rotada
I2 = imrotate(I2, 30);

% Detectar puntos de interés
pts1 = detectSURFFeatures(I1);
pts2 = detectSURFFeatures(I2);

% Extraer descriptores
[f1, vpts1] = extractFeatures(I1, pts1);
[f2, vpts2] = extractFeatures(I2, pts2);

% Buscar coincidencias
indexPairs = matchFeatures(f1, f2);

matched1 = vpts1(indexPairs(:,1));
matched2 = vpts2(indexPairs(:,2));

% Mostrar matches
figure;
showMatchedFeatures(I1, I2, matched1, matched2);
title('Coincidencias con matchFeatures');

disp('-> matchFeatures compara descriptores y encuentra correspondencias entre puntos clave.');

%% -------------------------------
% c) Matriz de transformación con pinv
% -------------------------------
% Queremos hallar una matriz H tal que:  x2 ? H * x1
% Tomamos algunos puntos correspondientes (ejemplo manual)
movingPoints  = [10 10; 100 20; 50 150; 200 200]; % puntos en I1
fixedPoints   = [15 15; 120 25; 70 180; 210 220]; % puntos en I2 (simulados)

% Calcular H con estimación lineal
A = [];
b = [];
for i = 1:size(movingPoints,1)
    x = movingPoints(i,1); y = movingPoints(i,2);
    u = fixedPoints(i,1); v = fixedPoints(i,2);
    A = [A; x y 1 0 0 0 -u*x -u*y; 0 0 0 x y 1 -v*x -v*y];
    b = [b; u; v];
end

h = pinv(A)*b;
H = [h(1) h(2) h(3);
     h(4) h(5) h(6);
     h(7) h(8) 1];

tform_est = projective2d(H');
I_warp = imwarp(I1, tform_est);

figure;
subplot(1,2,1); imshow(I1); title('Original I1');
subplot(1,2,2); imshow(I_warp); title('I1 transformada con H');

disp('-> El resultado NO es idéntico porque:');
disp('   1) Usamos pocos puntos (ajuste aproximado).');
disp('   2) pinv minimiza en el sentido de mínimos cuadrados.');
disp('   3) Puede haber pérdida de información, aliasing o interpolación en imwarp.');

%% =========================
% 5. IMÁGENES ANISOTRÓPICAS (DICOM)
% =====================================================
% TRABAJO CON VOLUMEN DICOM (MATLAB 2016)
% ============================
clear; clc; close all;

% Carpeta con cortes DICOM
folder = 'CT_Colon';  % <-- cambiar a tu carpeta
files = dir(fullfile(folder, '*.dcm'));
nSlices = numel(files);

% Leer primer slice para obtener info
info = dicominfo(fullfile(folder, files(1).name));
firstSlice = dicomread(fullfile(folder, files(1).name));
[nx, ny] = size(firstSlice);

% Inicializar volumen
V = zeros(nx, ny, nSlices, 'double');

% Leer todos los cortes
for k = 1:nSlices
    fname = fullfile(folder, files(k).name);
    V(:,:,k) = double(dicomread(fname));
end

% Ordenar cortes según posición (a veces vienen mezclados)
zPos = zeros(1,nSlices);
for k = 1:nSlices
    infoK = dicominfo(fullfile(folder, files(k).name));
    if isfield(infoK,'ImagePositionPatient')
        zPos(k) = infoK.ImagePositionPatient(3);
    else
        zPos(k) = k; % fallback
    end
end
[~, idx] = sort(zPos);
V = V(:,:,idx);

% ============================
% RESOLUCIÓN FÍSICA
% ============================
pixSpacing = info.PixelSpacing;      % [dy, dx] en mm
if isfield(info,'SpacingBetweenSlices')
    sliceThickness = info.SpacingBetweenSlices;
else
    sliceThickness = info.SliceThickness;
end
voxelSize = [pixSpacing(1), pixSpacing(2), sliceThickness]; % [dy dx dz]

[nx, ny, nz] = size(V);
x = (0:nx-1) * voxelSize(2); % eje X físico
y = (0:ny-1) * voxelSize(1); % eje Y físico
z = (0:nz-1) * voxelSize(3); % eje Z físico

%% ============================
% a) RECONSTRUCCIÓN CORONAL Y SAGITAL
% ============================

% CORONAL (fijo x)
x0 = round(nx/2);
[Y,Z] = meshgrid(y,z);
X = x(x0)*ones(size(Y));

coronal_lin = interp3(x,y,z,V, X,Y,Z, 'linear', 0);

coronal_rot = imrotate(coronal_lin', 90, 'bilinear', 'loose');
figure; imshow(coronal_rot, []);
title('Corte coronal rotado 45° (sin pérdida)');

% SAGITAL (fijo y)
y0 = round(ny/2);
[X,Z] = meshgrid(x,z);
Y = y(y0)*ones(size(X));

sagittal_lin = interp3(x,y,z,V, X,Y,Z, 'linear', 0);
sagittal_rot = imrotate(sagittal_lin', 90, 'bilinear', 'loose');
figure; imshow(sagittal_rot, []);
title('Corte sagital rotado 45° (sin pérdida)');

%% ============================
% b) CORTE OBLICUO (TRILINEAL)
% ============================
P0 = [x(nx/2), y(ny/2), z(round(nz/2))]; % centro del volumen
u = [1, 0.5, 0];  % vector director en el plano
v = [0, 0.5, 1];
u = u / norm(u);
v = v / norm(v);

Nu = 256; Nv = 256; 
du = 1; dv = 1;  

[U,Vv] = meshgrid((0:Nu-1)*du, (0:Nv-1)*dv);

Xo = P0(1) + U*u(1) + Vv*v(1);
Yo = P0(2) + U*u(2) + Vv*v(2);
Zo = P0(3) + U*u(3) + Vv*v(3);

oblique = interp3(x,y,z,V, Xo,Yo,Zo, 'linear', 0);

figure; imshow(oblique', []); title('Corte oblicuo (trilineal)');
axis on; daspect([1 1 1]);
