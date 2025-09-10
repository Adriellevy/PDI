function filtro_ladrillos()
    
% 1. Cargar imagen y FFT
I = imread('Ladrillos.png');
I = im2double(I);
F = fft2(I);
Fshift = fftshift(F);
[M, N] = size(I);

% Crear ventana
fig = figure('Name','Filtros Frecuenciales','NumberTitle','off','Position',[100 100 1000 600]);

% Guardar datos en la figura
setappdata(fig,'I',I);
setappdata(fig,'Fshift',Fshift);
setappdata(fig,'M',M);
setappdata(fig,'N',N);

% ========================
% 2. Crear sliders (abajo de la figura)
% ========================
% Slider horizontal
sliderH = uicontrol('Style','slider','Min',1,'Max',50,'Value',5,...
    'Units','normalized','Position',[0.2 0.02 0.25 0.04],...
    'Callback',@(src,~) actualizar(fig));
uicontrol('Style','text','Units','normalized','Position',[0.2 0.07 0.25 0.03],...
    'String','Ancho filtro horizontal');

% Slider vertical
sliderV = uicontrol('Style','slider','Min',1,'Max',50,'Value',15,...
    'Units','normalized','Position',[0.55 0.02 0.25 0.04],...
    'Callback',@(src,~) actualizar(fig));
uicontrol('Style','text','Units','normalized','Position',[0.55 0.07 0.25 0.03],...
    'String','Ancho filtro vertical');

% Guardar handles de sliders
setappdata(fig,'sliderH',sliderH);
setappdata(fig,'sliderV',sliderV);
end

function actualizar(fig)
    % Recuperar variables
    I = getappdata(fig,'I');
    Fshift = getappdata(fig,'Fshift');
    M = getappdata(fig,'M');
    N = getappdata(fig,'N');

    % Leer valores de sliders
    sliders = findall(fig,'Style','slider');
    ancho_h = round(get(sliders(2),'Value')); % horizontal
    ancho_v = round(get(sliders(1),'Value')); % vertical

    cx = N/2; cy = M/2;

    % ========================
    % 3. Construcción de Filtros
    % ========================
    % Filtro horizontal (líneas horizontales en la imagen)
    mask_h = zeros(M, N);
    mask_h(:, cx-ancho_h:cx+ancho_h) = 1;

    % Filtro vertical (líneas verticales en la imagen)
    mask_v = zeros(M, N);
    mask_v(cy-ancho_v:cy+ancho_v, :) = 1;

    % Filtro combinado
    mask_hv = mask_h | mask_v;

    % ========================
    % 4. Aplicación de los filtros
    % ========================
    Ih  = ifft2(ifftshift(Fshift .* mask_h));
    Iv  = ifft2(ifftshift(Fshift .* mask_v));
    Ihv = ifft2(ifftshift(Fshift .* mask_hv));

    % ========================
    % 5. Visualización
    % ========================
    clf(fig);
    subplot(2,3,1), imshow(I, []), title('Imagen original');
    subplot(2,3,2), imshow(log(1+abs(Fshift)), []), title('Espectro log');

    subplot(2,3,3), imshow(abs(Ih), []), title(['Horizontales (ancho=',num2str(ancho_h),')']);
    subplot(2,3,4), imshow(mask_h, []), title('Máscara horizontales');

    subplot(2,3,5), imshow(abs(Iv), []), title(['Verticales (ancho=',num2str(ancho_v),')']);
    subplot(2,3,6), imshow(abs(Ihv), []), title('Horizontales + Verticales');
end
