%Ejercicio a
%help fspecial
%Ejercicio b 
%help filter2
%Ejercicio c-i Aplicar Media Movil ergo Aplicar Avergae
% Media_Mov1=fspecial('average',3);
% Media_Mov2=fspecial('average',5);
% Media_Mov3=fspecial('average',12);
% 
% img=imread('test.bmp');
% img=im2double(img);
% ImagenFiltradaMediaMov1 =filter2(Media_Mov1,img);
% ImagenFiltradaMediaMov2=filter2(Media_Mov2,img);
% ImagenFiltradaMediaMov3 =filter2(Media_Mov3,img);
% figure(1)
% subplot(2,2,1)
% imshow(img)
% subplot(2,2,2)
% imshow(ImagenFiltradaMediaMov1)
% subplot(2,2,3)
% imshow(ImagenFiltradaMediaMov2)
% subplot(2,2,4)
% imshow(ImagenFiltradaMediaMov3)
% 
% % Ejercicio c.ii - Filtros Gaussianos
% Gauss1 = fspecial('gaussian', 3, 0.5);
% Gauss2 = fspecial('gaussian', 5, 1);
% Gauss3 = fspecial('gaussian', 9, 2);
% 
% ImagenGauss1 = filter2(Gauss1, img);
% ImagenGauss2 = filter2(Gauss2, img);
% ImagenGauss3 = filter2(Gauss3, img);
% 
% figure(2)
% subplot(2,2,1)
% imshow(img), title('Original')
% subplot(2,2,2)
% imshow(ImagenGauss1), title('Gauss 3x3, sigma=0.5')
% subplot(2,2,3)
% imshow(ImagenGauss2), title('Gauss 5x5, sigma=1')
% subplot(2,2,4)
% imshow(ImagenGauss3), title('Gauss 9x9, sigma=2')

% % Ejercicio c.iii - Filtro Laplaciano
% Lap1 = fspecial('laplacian', 0);   % alfa = 0
% Lap2 = fspecial('laplacian', 0.5); % alfa = 0.2
% Lap3 = fspecial('laplacian', 1); % alfa = 0.5
% 
% ImagenLap1 = filter2(Lap1, img);
% ImagenLap2 = filter2(Lap2, img);
% ImagenLap3 = filter2(Lap3, img);
% 
% figure(3)
% subplot(2,2,1)
% imshow(img), title('Original')
% subplot(2,2,2)
% imshow(ImagenLap1), title('Laplaciano ?=0')
% subplot(2,2,3)
% imshow(ImagenLap2), title('Laplaciano ?=0.5')
% subplot(2,2,4)
% imshow(ImagenLap3), title('Laplaciano ?=1')

% Ejercicio c.iv - Filtro LOG Laplacian of gausiean
% LOG1 = fspecial('log',3 ,0.5);   % alfa = 0
% LOG2 = fspecial('log',5 ,0.3); % alfa = 0.2
% LOG3 = fspecial('log',9,0.1); % alfa = 0.5
% 
% ImagenLOG1 = filter2(LOG1, img);
% ImagenLOG2 = filter2(LOG2, img);
% ImagenLOG3 = filter2(LOG3, img);
% 
% figure(4)
% subplot(2,2,1)
% imshow(img), title('Original')
% subplot(2,2,2)
% imshow(ImagenLOG1), title('LOG ?=0.5')
% subplot(2,2,3)
% imshow(ImagenLOG2), title('LOG ?=0.3')
% subplot(2,2,4)
% imshow(ImagenLOG3), title('LOG ?=0.1')

%c-iv
% Prewitt_H = fspecial('prewitt');      % Por defecto es horizontal
% Prewitt_V = Prewitt_H';               % Transponiendo obtenemos el vertical
% 
% ImagenPrewittH = filter2(Prewitt_H, img);
% ImagenPrewittV = filter2(Prewitt_V, img);
% 
% figure(4)
% subplot(1,3,1), imshow(img), title('Original')
% subplot(1,3,2), imshow(ImagenPrewittH,[]), title('Prewitt Horizontal')
% subplot(1,3,3), imshow(ImagenPrewittV,[]), title('Prewitt Vertical')
% %c-vi
% 
% % Ejercicio c.v - Filtro Sobel
% Sobel_H = fspecial('sobel');      % Por defecto es horizontal
% Sobel_V = Sobel_H';               % Vertical
% 
% ImagenSobelH = filter2(Sobel_H, img);
% ImagenSobelV = filter2(Sobel_V, img);
% 
% figure(5)
% subplot(1,3,1), imshow(img), title('Original')
% subplot(1,3,2), imshow(ImagenSobelH,[]), title('Sobel Horizontal')
% subplot(1,3,3), imshow(ImagenSobelV,[]), title('Sobel Vertical')


% % 1.d - Filtro pasa-altos convencional
% h_lp = fspecial('average', 3);  % Filtro pasa-bajos 3x3
% h_hp = -h_lp;                   % Negativo del low-pass
% h_hp(2,2) = h_hp(2,2) + 1;      % Delta en el centro
% 
% img_hp = filter2(h_hp, img);
% 
% figure(11)
% subplot(1,2,1), imshow(img), title('Original')
% subplot(1,2,2), imshow(img_hp,[]), title('Filtro Pasa-Altos 3x3')
% 
% % 1.e - High-Boost Filtering
% A_values = [1, 2, 8];   % Distintos valores de A
% 
% figure(12)
% subplot(2,2,1), imshow(img), title('Original')
% 
% for k = 1:length(A_values)
%     A = A_values(k);
%     h_hb = -h_lp; 
%     h_hb(2,2) = h_hb(2,2) + A;   
%     
%     img_hb = filter2(h_hb, img);
%     
%     subplot(2,2,k+1)
%     imshow(img_hb)
%     title(['High-Boost A=', num2str(A)])
% end