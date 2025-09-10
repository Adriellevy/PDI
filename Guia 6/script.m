 % ====== DEMO PRINCIPAL ======
    % Tamaños de imagen más comunes (puedes elegir uno):
    tamanos = [128, 256, 512, 1024]; 
    N = 256; % tamaño por defecto (256x256)

    % Ejemplos de uso
    img1 = pulso_rectangular(N, N, 80, 40);       % ancho=80, alto=40
    img2 = circulo_centrado(N, N, 60);            % radio=60
    img3 = cruz(N, N, 5);                         % ancho=5
    img4v = barras(N, N, 8, 'vertical');          % 8 periodos verticales
    img4h = barras(N, N, 8, 'horizontal');        % 8 periodos horizontales
    img5v = senoidal(N, N, 6, 'vertical');        % senoidal vertical 6 periodos
    img5h = senoidal(N, N, 6, 'horizontal');      % senoidal horizontal 6 periodos

    % Mostrar ejemplos
    figure;
    subplot(2,3,1), imshow(img1, []), title('Pulso rectangular');
    subplot(2,3,2), imshow(img2, []), title('Círculo centrado');
    subplot(2,3,3), imshow(img3, []), title('Cruz');
    subplot(2,3,4), imshow(img4v, []), title('Barras verticales');
    subplot(2,3,5), imshow(img4h, []), title('Barras horizontales');
    subplot(2,3,6), imshow(img5v, []), title('Senoidal vertical');
    
  %% ======================== FILTRADO AVANZADO CON INTERFAZ =====================

% Leer la imagen
I = imread('Ladrillos.png');
I = im2double(I);

% FFT 2D
F = fft2(I);
Fshift = fftshift(F); % centro de la transformada
[M, N] = size(I);

% Valores iniciales de los anchos
ancho_h = 5;
ancho_v = 15;

% ---------------------------
% Crear figura y plots
hFig = figure('Name','Filtrado Avanzado','NumberTitle','off');

% --- Sección 1: Filtro + filtrado ---
ax1 = subplot(2,2,1);
imshow(I, []); title('Imagen original');

ax2 = subplot(2,2,2);
imshow(log(1+abs(Fshift)), []); title('Espectro log');

ax4 = subplot(2,2,4); % Filtro vertical
title('Filtro Vertical + Resultado');

ax3 = subplot(2,2,3); % Original + suma de filtros
hImgSum = imshow(I, []); title('Original + Filtros');

% ---------------------------
% Sliders para anchos de filtro
slider_h = uicontrol('Style','slider',...
    'Min',1,'Max',50,'Value',ancho_h,...
    'Position',[50 20 200 20]);

slider_v = uicontrol('Style','slider',...
    'Min',1,'Max',50,'Value',ancho_v,...
    'Position',[300 20 200 20]);

% Etiquetas de los sliders
uicontrol('Style','text','Position',[50 45 200 20],'String','Ancho Horizontal');
uicontrol('Style','text','Position',[300 45 200 20],'String','Ancho Vertical');

% ---------------------------
% Callback que actualiza plots
set(slider_h, 'Callback', @(~,~) actualizar(I, Fshift, M, N, slider_h, slider_v));
set(slider_v, 'Callback', @(~,~) actualizar(I, Fshift, M, N, slider_h, slider_v));

% ---------------------------
% Actualizar plots iniciales
actualizar(I, Fshift, M, N, slider_h, slider_v);