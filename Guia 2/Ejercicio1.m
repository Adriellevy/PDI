% Leer imagen Lena
lena = imread('lena.png'); % Asegúrate que 'lena.png' esté en la carpeta de trabajo

% Separar los canales RGB
R = lena(:,:,1);
G = lena(:,:,2);
B = lena(:,:,3);

% Crear figura
figure;

% Histograma canal Rojo
subplot(3,1,1); % 3 filas, 1 columna, posición 1
imhist(R);
title('Histograma Canal Rojo');
xlabel('Nivel de Intensidad');
ylabel('Frecuencia');

% Histograma canal Verde
subplot(3,1,2); % posición 2
imhist(G);
title('Histograma Canal Verde');
xlabel('Nivel de Intensidad');
ylabel('Frecuencia');

% Histograma canal Azul
subplot(3,1,3); % posición 3
imhist(B);
title('Histograma Canal Azul');
xlabel('Nivel de Intensidad');
ylabel('Frecuencia');

% Ajustar espaciado
sgtitle('Histogramas de la Imagen Lena por Canal RGB');
