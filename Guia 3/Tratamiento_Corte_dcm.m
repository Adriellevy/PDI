
tags = dicominfo('Corte.dcm'); 
ImagenCT = dicomread(tags);

% aplicarTodosFiltros(ImagenCT)
bordes1 = edge(ImagenCT, 'canny', [0.1 0.3]);
bordes2 = edge(ImagenCT, 'canny', [0.2 0.4]);
bordes3 = edge(ImagenCT, 'canny', [0.3 0.7]);

figure;
subplot(1,3,1), imshow(bordes1), title('Canny [0.1, 0.3]');
subplot(1,3,2), imshow(bordes2), title('Canny [0.2, 0.4]');
subplot(1,3,3), imshow(bordes3), title('Canny [0.3, 0.7]');


% ImagenPasaAltos= filtroPasaAltos(ImagenCT);%Filtra muy bien los contornos --> gauseano del laplaciano
%Que funciones filtran bien el corte para ver la aorta: DOG,LOG,Prewitt
%Funciones que no dieron nada: HighBoost, PasaAltos y Sobel
% figure(1)
% subplot(1,1,1)
% imshow(ImagenFiltradaDog,[]); %Aparecen bordes raros o cosas borrosas

%Una idea interesante es hacer un Pa para ver los contornos,pero no fue la
%gran cosa
% 
% Imagenrestada=im2double(ImagenCT)-ImagenPasaAltos{1}; 
% figure(2)
% imshow(Imagenrestada,[])

% 
% ImagenFiltradaLOG = filtroLoG(ImagenCT,3);
% ImagenFiltradaPrewit=filtroPrewitt(ImagenCT,2); 
% ImagenFiltradaLaplacian=filtroLaplaciano(ImagenCT,3);
% imshow(edge(ImagenFiltradaLaplacian))
% imshow(edge(ImagenFiltradaLOG)+edge(ImagenFiltradaPrewit));

% 
% ImagenFiltradaH=filter2(filtroprewit',ImagenCT);
% ImagenFiltradaV=filter2(filtroprewit,ImagenCT);
% ImagenSumaVectoresGradientes=ImagenFiltradaV+ImagenFiltradaH; 
% ImagenFiltradaMediana = medfilt2(ImagenSumaVectoresGradientes, [3 3]);
% figure(2)
% subplot(1,2,1); 
% imshow(ImagenSumaVectoresGradientes)
% subplot(1,2,2)
% imshow(ImagenFiltradaMediana)