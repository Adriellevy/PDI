img = imread('test.bmp');
img = im2double(img);
% Ejercicio a.i

% figure(8)
% for p = 5:5:50
%     img_ruido = imnoise(img, 'salt & pepper', p/100); % p%
%     subplot(2,5,p/5)
%     imshow(img_ruido), title(['Ruido ', num2str(p), '%'])
% end

%Ejercicio a.ii
% % Filtros suavizantes
% f_avg = fspecial('average', 3);
% f_gauss = fspecial('gaussian', 5, 1);
% 
% img_avg = filter2(f_avg, img_ruido);
% img_gauss = filter2(f_gauss, img_ruido);
% 
% figure(9)
% subplot(1,3,1), imshow(img_ruido), title('Imagen con Ruido 20%')
% subplot(1,3,2), imshow(img_avg), title('Filtro Promedio 3x3')
% subplot(1,3,3), imshow(img_gauss), title('Filtro Gaussiano 5x5, ?=1')
% 
% % Ejercicio a.iii - Filtro de la mediana
% figure(10)
% 
% for p = 5:5:50
%     img_ruido = imnoise(img, 'salt & pepper', p/100);
% 
%     img_med3 = medfilt2(img_ruido, [3 3]); % ventana 3x3
%     img_med5 = medfilt2(img_ruido, [5 5]); % ventana 5x5
% 
%     subplot(5,3,(p/5-1)*3+1), imshow(img_ruido), title(['Ruido ', num2str(p), '%'])
%     subplot(5,3,(p/5-1)*3+2), imshow(img_med3), title('Mediana 3x3')
%     subplot(5,3,(p/5-1)*3+3), imshow(img_med5), title('Mediana 5x5')
% end


% % C-ii
% bordes1 = edge(img, 'canny', [0 0.15]);
% bordes2 = edge(img, 'canny', [0.2 0.4]);
% bordes3 = edge(img, 'canny', [0.3 0.7]);
% 
% figure;
% subplot(1,3,1), imshow(bordes1), title('Canny [0.1, 0.3]');
% subplot(1,3,2), imshow(bordes2), title('Canny [0.2, 0.4]');
% subplot(1,3,3), imshow(bordes3), title('Canny [0.3, 0.7]');
% C-iii
% bordesS1 = edge(img, 'canny', [], 0.5);
% bordesS2 = edge(img, 'canny', [], 1);
% bordesS3 = edge(img, 'canny', [], 2);
% 
% figure;
% subplot(1,3,1), imshow(bordesS1), title('Canny σ=0.5');
% subplot(1,3,2), imshow(bordesS2), title('Canny σ=1');
% subplot(1,3,3), imshow(bordesS3), title('Canny σ=2');
% C-iiii
% [Gx, Gy] = imgradientxy(img, 'sobel');
% [Gmag, ~] = imgradient(Gx, Gy);
% 
% lowT  = prctile(Gmag(:), 10) / max(Gmag(:));
% highT = prctile(Gmag(:), 90) / max(Gmag(:));
% 
% bordesP = edge(img, 'canny', [lowT highT]);
% 
% figure;
% imshow(bordesP), title(sprintf('Canny con umbrales percentiles [%.2f, %.2f]', lowT, highT));

%4
imgColor = im2double(imread('peppers.png'));

f1 = imbilatfilt(imgColor, 0.05, 2);  % σIntensity=0.05, σSpatial=2
f2 = imbilatfilt(imgColor, 0.1, 5);
f3 = imbilatfilt(imgColor, 0.2, 10);

figure;
subplot(2,2,1), imshow(imgColor), title('Original');
subplot(2,2,2), imshow(f1), title('Bilateral σI=0.05, σS=2');
subplot(2,2,3), imshow(f2), title('Bilateral σI=0.1, σS=5');
subplot(2,2,4), imshow(f3), title('Bilateral σI=0.2, σS=10');