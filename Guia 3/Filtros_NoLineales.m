img = imread('test.bmp');
img = im2double(img);

figure(8)
for p = 5:5:50
    img_ruido = imnoise(img, 'salt & pepper', p/100); % p%
    subplot(2,5,p/5)
    imshow(img_ruido), title(['Ruido ', num2str(p), '%'])
end

% Filtros suavizantes
f_avg = fspecial('average', 3);
f_gauss = fspecial('gaussian', 5, 1);

img_avg = filter2(f_avg, img_ruido);
img_gauss = filter2(f_gauss, img_ruido);

figure(9)
subplot(1,3,1), imshow(img_ruido), title('Imagen con Ruido 20%')
subplot(1,3,2), imshow(img_avg), title('Filtro Promedio 3x3')
subplot(1,3,3), imshow(img_gauss), title('Filtro Gaussiano 5x5, ?=1')
% Ejercicio a.iii - Filtro de la mediana
figure(10)
for p = 5:5:50
    img_ruido = imnoise(img, 'salt & pepper', p/100);
    
    img_med3 = medfilt2(img_ruido, [3 3]); % ventana 3x3
    img_med5 = medfilt2(img_ruido, [5 5]); % ventana 5x5
    
    subplot(5,3,(p/5-1)*3+1), imshow(img_ruido), title(['Ruido ', num2str(p), '%'])
    subplot(5,3,(p/5-1)*3+2), imshow(img_med3), title('Mediana 3x3')
    subplot(5,3,(p/5-1)*3+3), imshow(img_med5), title('Mediana 5x5')
end