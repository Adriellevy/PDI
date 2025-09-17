function [Q, theta] = hotellingPCA(I)
    % Procesamiento Hotelling (PCA) sobre una imagen
    % Entrada: imagen I (double)
    % Salida: matriz de covarianza Q, ángulo principal theta

    [nx, ny] = size(I);
    [X, Y] = meshgrid(1:ny, 1:nx);

    % Normalización a probabilidad
    I_norm = I / sum(I(:));

    % Centro de masa (coordenadas medias)
    x_mean = sum(sum(X .* I_norm));
    y_mean = sum(sum(Y .* I_norm));

    % --- Desplazamos coordenadas al origen ---
    Xc = X - x_mean;
    Yc = Y - y_mean;

    % Matriz de covarianza
    cov_xx = sum(sum(Xc.^2 .* I_norm));
    cov_yy = sum(sum(Yc.^2 .* I_norm));
    cov_xy = sum(sum(Xc .* Yc .* I_norm));
    Q = [cov_xx cov_xy; cov_xy cov_yy];

    % Autovalores y autovectores
    [V, D] = eig(Q);
    [~, idx] = max(diag(D));
    pc1 = V(:, idx);

    % Ángulo de la primera componente principal
    theta = atan2(pc1(2), pc1(1));
end
