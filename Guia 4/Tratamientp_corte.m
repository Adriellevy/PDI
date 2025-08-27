I = dicomread('Corte.dcm');
% Convertir a binaria si es necesario (muchas operaciones morfológicas requieren binario)
BW = imbinarize(I);

% Definir distintos elementos estructurantes
se1 = strel('disk', 5);      % disco de radio 5
se2 = strel('rectangle', [10 5]); % rectángulo 10x5
se3 = strel('line', 15, 45); % línea de 15 píxeles en 45°
se4 = strel('diamond', 4);   % diamante de radio 4

% Aplicar clausura (dilatación seguida de erosión)
BW1 = imclose(BW, se1);
BW2 = imclose(BW, se2);
BW3 = imclose(BW, se3);
BW4 = imclose(BW, se4);

% Mostrar resultados
figure;
subplot(2,2,1), imshow(BW1), title('Clausura con disco r=5');
subplot(2,2,2), imshow(BW2), title('Clausura con rectángulo 10x5');
subplot(2,2,3), imshow(BW3), title('Clausura con línea 15, 45°');
subplot(2,2,4), imshow(BW4), title('Clausura con diamante r=4');