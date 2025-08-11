%Ejercicio 1
% Lena = imread("Lena.png");
% imshow(Lena)
% Lenagris=rgb2gray(Lena);

%Ejercicio 2
%Mostrar los canales
% MatVacia= zeros(220,220,3,'uint8');
% Rojo=MatVacia; 
% Verde=MatVacia; 
% Azul=MatVacia; 
% Rojo(:,:,1) = Lena(:,:,1); 
% Verde(:,:,2) = Lena(:,:,2); 
% Azul(:,:,3) = Lena(:,:,3); 
% imshow(Rojo)

%Ejercicio 3
%Modificar Ventanas
% LenaAuxiliar=Lena; 
% LenaAuxiliar(Lena<100)=100; %Codigo problematico
% LenaAuxiliar(Lena>150)=150; %codigo problematico
% imshow(LenaAuxiliar)
% figure(2)
% imshow(Lena)

% LenaAuxiliar=Lena; 
% LenaAuxiliar=Lena(100:220,150:200,:);
% imshow(LenaAuxiliar)

% impixelinfo(); para mostrar la informacion del coursor


%Ejercicio 4
%Contestando las preguntas de la consigna: 
%se nos pregunta cual es el tipo de dato contenido dentro de un pixel de
%una imagen, la respuesta es un uint8/16/32. 
%El rango de valores es de 0 a 255, osea un total de 256 posibles valores

% MatVacia= zeros(220,220,3,'double');
% Rojo=MatVacia; 
% Verde=MatVacia; 
% Azul=MatVacia; 
% Rojo(:,:,1) = Lena(:,:,1); 
% Verde(:,:,2) = Lena(:,:,2); 
% Azul(:,:,3) = Lena(:,:,3); 
% imshow(Azul)
% Tambien se puede ver en este codigo 

%Lo que se obseva al pasar de dato es una saturacion en cualquiera de los
%canales justamente por el overflow que ocurrirá ya que un tipo double
%puede contener menos numero en la misma cantidad de bits, ya que utiliza 
% la coma. 
% 
% LenaDouble = double(Lena);   % Convertimos a double
% figure;
% imshow(LenaDouble);          % Mostramos directamente
% title('Imagen en double sin escalar');
% LenaEscalada = LenaDouble / 255;  % Normalizamos a [0, 1]
% figure;
% imshow(LenaEscalada);             % Ahora sí, bien visualizada
% title('Imagen en double normalizada (0 a 1)');
% 

%Cuando cambiamos /512 se vuelve mas oscura (menos saturada), cuando lo
%cambiamos a /128 se vuelve mas saturada. Justamente porque el valor
%numerico en los distintos canales se vuelve mas grande(mas saturada) o mas
%chica (menos saturada)

%Ejercicio 5 resolucion espacial
% Lena4=Lena(1:4:end,1:4:end,:);
% Lena8=Lena(1:8:end,1:8:end,:);
% Lena16=Lena(1:16:end,1:16:end,:);
% Lena32=Lena(1:32:end,1:32:end,:);
% 
% figure;
% 
% % Imagen original (fila 1, columnas 1-2)
% subplot(3,2,[1 2]);  % Ocupa ambas columnas de la primera fila
% imshow(Lena, []);
% title('1. Imagen original');
% 
% % Imagen dividido 4
% subplot(3,2,3);  % Fila 2, Columna 1
% imshow(Lena4, []);
% title('2. Imagen dividido 4');
% 
% % Imagen dividido 8
% subplot(3,2,4);  % Fila 2, Columna 2
% imshow(Lena8, []);
% title('3. Imagen dividido 8');
% 
% % Imagen dividido 16
% subplot(3,2,5);  % Fila 3, Columna 1
% imshow(Lena16, []);
% title('4. Imagen dividido 16');
% 
% % Imagen dividido 32
% subplot(3,2,6);  % Fila 3, Columna 2
% imshow(Lena32, []);
% title('5. Imagen dividido 32');
% 
% 
% % Paso bajo simple: filtro gaussiano
% filtro = fspecial('gaussian', [5 5], 1.0);
% 
% % Aplicar sobremuestreo + filtro
% Lena4_upsampled = upsampleAndFilter(Lena4, size(Lena), filtro);
% Lena8_upsampled = upsampleAndFilter(Lena8, size(Lena), filtro);
% Lena16_upsampled = upsampleAndFilter(Lena16, size(Lena), filtro);
% Lena32_upsampled = upsampleAndFilter(Lena32, size(Lena), filtro);
% 
% % Mostrar resultados
% figure;
% 
% subplot(3,2,[1 2]);
% imshow(Lena, []);
% title('1. Imagen original');
% 
% subplot(3,2,3);
% imshow(Lena4_upsampled, []);
% title('2. Submuestreo x4 + SobreMuestreo + Filtro');
% 
% subplot(3,2,4);
% imshow(Lena8_upsampled, []);
% title('3. Submuestreo x8 + SobreMuestreo + Filtro');
% 
% subplot(3,2,5);
% imshow(Lena16_upsampled, []);
% title('4. Submuestreo x16 + SobreMuestreo + Filtro');
% 
% subplot(3,2,6);
% imshow(Lena32_upsampled, []);
% title('5. Submuestreo x32 + SobreMuestreo + Filtro');


% filtroEspacialIdeal() Queda raro honestamente pero es interesante

% Ejercicio 6
%La imagen es una colonoscopia mediante tomografía computariazada 
% X = dicomread("Corte.dcm");
% tags = dicominfo("Corte.dcm"); 
% X = dicomread(tags);
% figure
% imshow(X,[]);
% imcontrast Sirve para ajustar la ventana de contraste, pero es lineal.

% -----------------------------------------------------------

%Ejercicio 7 Ventaneo: 
%Ahora yo quiero poder obvservar los distintos tipos de tejidos
%Una forma de generar vetanas es mediante una nueva transferencia, la cual
%esta dada por O(i) = C*i + B. B es el brillo y C contraste. 

%Vocabulario HU son todos los valores de i. Pero para tener el formato
%Hounsonfild se realiza lo siguiente: 
TC = int16(dicomread(tags));

%Tengo 3 ventanas en general para poder observar bien un tejido
% Los valores para estas ventanas son: 
% Para hueso: WL=300 y WL 200. C/W = 1000,2000
% Para Tejido blando: WL=40 y WW = 400. C/w = -50, 400. 
% Para Pulmones:WL=-600, WW=1600. c/W=-600,1700
%

%Centro en 1000 y un ancho de 280 veo el esofago, la aorta y 3 organos que
%no identifico del todo
%Valor maximo de algun bit = 2333
%tags.WindowCenter = 40;-600, tags.WindowWidth=[400;1500]
%

%Preguntas: 
%Mis Luts son mis nuevas transferencias? 

%La funcion imcontrast me muestra mis intensidades del sistema
%representacional en funcion de la intensidad de la imagen? 
%o esta funcion me muestra mi histograma de bits en funcion
%de mi intensidad? 

%Re escalo la imagen en unidades HU
% TC = TC * tags.RescaleSlope + tags.RescaleIntercept;
% imshow(TC,[]);
% imcontrast

% imshow(TC,[]);
% imcontrast
%LUP's Ejercicios guias
%a)
valor_maximo = max(TC(:));
valor_minimo = min(TC(:));
%b)
%Para generar una nueva lut genero una nueva recta, donde tenga un 0 y mi
%pendiente considere todos los valores de la intesidad y los plasme en mi
%sistema representacional de 256 valores posibles
in = valor_minimo:valor_maximo;
% c = (256/(valor_maximo - valor_minimo + 1));
b = -c*valor_minimo;
LUT = uint8(c*in + b);
out = LUT(TC - valor_minimo + 1);
figure()
imshow(out)
imcontrast