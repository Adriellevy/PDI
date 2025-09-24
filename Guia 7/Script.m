%% 
%Transformada de Hotelling
% I=imread('MRI.png');
% imshow(MRI);
% 2. Calcular centro de masas con ponderación por intensidad
[rows, cols] = size(I);
[x, y] = meshgrid(1:cols, 1:rows);

m_x = sum(sum(x .* I)) / sum(I(:));
m_y = sum(sum(y .* I)) / sum(I(:));

%% 3. Calcular matriz de covarianza (Q)
Qxx = sum(sum(((x - m_x).^2) .* I)) / sum(I(:));
Qyy = sum(sum(((y - m_y).^2) .* I)) / sum(I(:));
Qxy = sum(sum(((x - m_x) .* (y - m_y)) .* I)) / sum(I(:));

Q = [Qxx Qxy; Qxy Qyy];

% 4. Autovalores y autovectores
[V, D] = eig(Q);

% Ordenar para quedarnos con la componente principal (mayor valor propio)
[~, idx] = max(diag(D));
pc1 = V(:, idx);

% 5. Ángulo de la primera componente principal
theta = atan2(pc1(2), pc1(1)) * 180/pi;

% 6. Rotar la imagen para alinearla
I_rot = imrotate(I, -theta, 'bilinear', 'crop');

figure;
subplot(1,2,1); imshow(I); title('Imagen Original');
subplot(1,2,2); imshow(I_rot); title('Imagen Alineada con PCA');

%% Ejecutar interfaz
interfazHotelling(I);