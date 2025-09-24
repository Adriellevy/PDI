function HotellingGUI(I, Q, theta)
    % Interfaz gráfica de la transformada de Hotelling con comparación PCA y manual

    % Autovalores y autovectores de Q
    [V, ~] = eig(Q);

    % Crear ventana
    f = figure('Name', 'Transformada de Hotelling con Slider', ...
               'Position', [50 100 1500 500]);

    % --- Imagen original (izquierda) ---
    ax0 = axes('Parent', f, 'Position', [0.05 0.25 0.25 0.65]);
    imshow(uint8(I), 'Parent', ax0);
    title(ax0, 'Imagen original');

    % Graficar vectores principales encima
    [nx, ny] = size(I);
    x_center = ny/2;
    y_center = nx/2;
    scale = min(nx, ny) / 4;
    hold(ax0, 'on');
    quiver(ax0, x_center, y_center, V(1,1)*scale, V(2,1)*scale, ...
        'r', 'LineWidth', 2, 'MaxHeadSize', 2);
    quiver(ax0, x_center, y_center, V(1,2)*scale, V(2,2)*scale, ...
        'g', 'LineWidth', 2, 'MaxHeadSize', 2);

    legend(ax0, {'PC1', 'PC2'}, 'TextColor','w', 'Location','southeast');
    hold(ax0, 'off');

    % --- Imagen alineada PCA (centro-izq) ---
    ax1 = axes('Parent', f, 'Position', [0.35 0.25 0.25 0.65]);
    I_rotPCA = imrotate(I, theta*180/pi, 'bilinear', 'crop');
    imshow(uint8(I_rotPCA), 'Parent', ax1);
    title(ax1, sprintf('Alineada PCA (θ = %.2f°)', theta*180/pi));    

    % --- Imagen con rotación manual (centro-der) ---
    ax2 = axes('Parent', f, 'Position', [0.65 0.25 0.25 0.65]);
    imshow(I, [], 'Parent', ax2);
    title(ax2, 'Rotación manual');

    % --- Panel de texto (derecha) ---
    hText = uicontrol('Style', 'text', ...
        'Units', 'normalized', ...
        'Position', [0.9 0.25 0.09 0.65], ...
        'FontSize', 11, ...
        'HorizontalAlignment', 'left', ...
        'BackgroundColor', get(f, 'Color'));

    % --- Slider (abajo centrado) ---
    uicontrol('Style', 'slider', ...
        'Min', -180, 'Max', 180, 'Value', 0, ...
        'Units', 'normalized', ...
        'Position', [0.65 0.05 0.25 0.05], ...
        'Callback', @(src, ~) rotateImage(src, I, ax2, hText));

    % Mostrar valores iniciales
    updateCovText(I, 0, hText);
end

%% --- SUBFUNCIONES INTERNAS ---
function rotateImage(slider, I, ax, hText)
    angle = get(slider, 'Value');
    I_rot = imrotate(I, angle, 'bilinear', 'crop');
    imshow(uint8(I_rot), [], 'Parent', ax);
    title(ax, sprintf('Rotación manual (%.1f°)', angle));

    % Actualizar covarianza
    updateCovText(I_rot, angle, hText);
end

function updateCovText(I, angle, hText)
    [nx, ny] = size(I);
    [X, Y] = meshgrid(1:ny, 1:nx);
    I_norm = double(I) / sum(I(:));

    % Medias ponderadas
    x_mean = sum(sum(X .* I_norm));
    y_mean = sum(sum(Y .* I_norm));

    % Matriz de covarianza
    cov_xx = sum(sum((X - x_mean).^2 .* I_norm));
    cov_yy = sum(sum((Y - y_mean).^2 .* I_norm));
    cov_xy = sum(sum((X - x_mean) .* (Y - y_mean) .* I_norm));

    % Texto en panel
    set(hText, 'String', sprintf([ ...
        'Ángulo = %.1f°\n\n' ...
        'Matriz de covarianza Q:\n' ...
        '[%.2f   %.2f;\n %.2f   %.2f]\n\n' ...
        'Varianza X = %.2f\n' ...
        'Varianza Y = %.2f\n' ...
        'Covarianza = %.2f'], ...
        angle, cov_xx, cov_xy, cov_xy, cov_yy, cov_xx, cov_yy, cov_xy));
end
