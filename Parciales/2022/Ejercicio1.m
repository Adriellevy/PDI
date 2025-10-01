% 1. Realizar un código en MATLAB que permita encontrar automáticamente los círculos 
% en las imágenes adjuntas. Debe informar el centro y radio de cada uno de los círculos. 
% La capacidad del script será evaluada en una cuarta imagen ("IMG4").

function [centros, radios] = Ejercicio1(filename)

img = imread(filename);
subplot(1,3,1)
imshow(img)

imgFiltrada = medfilt2(img, [5 5],'symmetric');
subplot(1,3,2)
imshow(imgFiltrada)

[centrosB1, radiosB1] = imfindcircles(imgFiltrada,[20 50], 'Sensitivity', 0.90, 'ObjectPolarity','bright');
[centrosB2, radiosB2] = imfindcircles(imgFiltrada,[51 100], 'Sensitivity', 0.97, 'ObjectPolarity','bright');
[centrosN1, radiosN1] = imfindcircles(imgFiltrada,[20 50], 'Sensitivity', 0.90, 'ObjectPolarity','dark');
[centrosN2, radiosN2] = imfindcircles(imgFiltrada,[51 100], 'Sensitivity', 0.97, 'ObjectPolarity','dark');

centros = [centrosB1; centrosB2; centrosN1; centrosN2];
radios = [radiosB1; radiosB2; radiosN1; radiosN2];

subplot(1,3,3)
imshow(imgFiltrada)
viscircles(centros, radios, 'EdgeColor', 'b');

end