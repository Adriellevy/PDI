%% Script maestro para probar LUTs
clear; clc; close all;

% Imagen de prueba
img = imread('corte.dcm');
if size(img, 3) == 3
    img = rgb2gray(img);
end
% Elegir opción:
% 1 = Brillo/Contraste
% 2 = Negativo
% 3 = Contrast Stretching
% 4 = Histograma Acumulado
% 5 = Umbralización
opcion = 5; 

switch opcion
    case 1  % Brillo y Contraste
        brillo = 30;       % positivo o negativo
        contraste = 1.2;   % >1 aumenta, <1 disminuye
        LUT = LUT_BrilloContraste(brillo, contraste);
        img_out = AplicarLUT(img, LUT);

        figure;
        subplot(2,2,1), imshow(img), title('Original');
        subplot(2,2,2), imshow(img_out), title('Brillo/Contraste');
        subplot(2,2,3), imhist(img), title('Histograma Original');
        subplot(2,2,4), imhist(img_out), title('Histograma Transformada');

    case 2  % Negativo
        LUT = LUT_Negativo();
        img_out = AplicarLUT(img, LUT);
        img_comp = imcomplement(img);

        figure;
        subplot(1,3,1), imshow(img), title('Original');
        subplot(1,3,2), imshow(img_out), title('Negativo LUT');
        subplot(1,3,3), imshow(img_comp), title('imcomplement');

    case 3  % Contrast Stretching
        p1 = [50, 30];
        p2 = [180, 220];
        LUT = LUT_Stretching(p1, p2);
        img_out = AplicarLUT(img, LUT);

        img_adj = imadjust(img, [p1(1)/255, p2(1)/255], [p1(2)/255, p2(2)/255]);

        figure;
        subplot(1,3,1), imshow(img), title('Original');
        subplot(1,3,2), imshow(img_out), title('Stretching LUT');
        subplot(1,3,3), imshow(img_adj), title('imadjust');

        figure;
        plot(0:255, double(LUT), 'r', 'LineWidth', 2), hold on;
        plot(0:255, 255*mat2gray(imadjust(uint8(0:255)', [p1(1)/255, p2(1)/255], [p1(2)/255, p2(2)/255])), 'b', 'LineWidth', 2);
        legend('LUT', 'imadjust');
        title('Funciones de transferencia');

    case 4  % Histograma acumulado (ecualización)
        [Hacum, LUT] = LUT_HistogramaAcumulado(img);
        img_eq = AplicarLUT(img, LUT);

        figure;
        subplot(2,2,1), imshow(img), title('Original');
        subplot(2,2,2), imshow(img_eq), title('Ecualizada LUT');
        subplot(2,2,3), imhist(img), title('Histograma Original');
        subplot(2,2,4), imhist(img_eq), title('Histograma Ecualizado');

        figure;
        plot(0:255, Hacum), hold on;
        plot([0 255], [0 1], 'r--'), title('Histograma acumulado vs identidad');
        legend('H acumulado', 'Identidad');

    case 5  % Umbralización
        % Umbral manual
        umbral = 100;
        LUT = LUT_Umbral(umbral);
        img_bin = AplicarLUT(img, LUT);

        % Umbral Otsu
        umbral_otsu = graythresh(img) * 255;
        LUT_otsu = LUT_Umbral(umbral_otsu);
        img_otsu = AplicarLUT(img, LUT_otsu);

        figure;
        subplot(2,2,1), imshow(img), title('Original');
        subplot(2,2,2), imshow(img_bin), title(['Binarizada, T=' num2str(umbral)]);
        subplot(2,2,3), imshow(img_otsu), title(['Binarizada Otsu, T=' num2str(round(umbral_otsu))]);
        subplot(2,2,4), imhist(img), title('Histograma');

    otherwise
        error('Opción no válida');
end