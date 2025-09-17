% --- SCRIPT PRINCIPAL ---
% Carga de la imagen y ejecución de la interfaz Hotelling

% 1. Cargar imagen
I = imread('MRI.png');
if size(I,3) == 3
    I = rgb2gray(I); % convertir a escala de grises si es RGB
end
I = double(I);

IHL = imread('Ladrillos.png');
I1 = imread('moneda.bmp');
I2 = imread('Fantoma círculos.bmp');
%% 2. Procesar la imagen con Hotelling (PCA)

[Q, theta] = hotellingPCA(I);

% 3. Mostrar resultados en interfaz gráfica
HotellingGUI(I, Q, theta);
%% HoughLines

% Caso original
applyHoughLines(IHL, 0.3, 10, 40);

% Rotar 30 grados y volver a analizar
Irot = imrotate(IHL, 30);
applyHoughLines(Irot, 0.3, 10, 40);

%% HoughCircles
applyHoughCircles(I1, [15 60], 0.9, 0.2);

% Caso fantoma
applyHoughCircles(I2, [15 80], 0.9, 0.1);