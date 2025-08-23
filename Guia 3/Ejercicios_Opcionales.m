% 4 "pesos relativos en base a la intensidad de la vecindad"
% img = im2double(imread('test.bmp'));

% f1 = imbilatfilt(img, 0.05, 2);  % σIntensity=0.05, σSpatial=2
% f2 = imbilatfilt(img, 0.1, 5);
% f3 = imbilatfilt(img, 0.2, 10);
% 
% figure;
% subplot(2,2,1), imshow(img), title('Original');
% subplot(2,2,2), imshow(f1), title('Bilateral σI=0.05, σS=2');
% subplot(2,2,3), imshow(f2), title('Bilateral σI=0.1, σS=5');
% subplot(2,2,4), imshow(f3), title('Bilateral σI=0.2, σS=10');

%5 "difusion de calor de los pixels"
img = im2double(imread('test.bmp'));
f1 = filtroAnisodiff(img, 10, 15, 0.2);
f2 = filtroAnisodiff(img, 20, 30, 0.2);

figure;
subplot(1,3,1), imshow(img), title('Original');
subplot(1,3,2), imshow(f1,[]), title('Anisotrópico k=15, it=10');
subplot(1,3,3), imshow(f2,[]), title('Anisotrópico k=30, it=20');