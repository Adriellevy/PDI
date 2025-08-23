function resultados = aplicarTodosFiltros(img)
    % Estructura para guardar resultados
    resultados = struct();

    % --- Filtros de suavizado / realce + mostrar muchos resultados ---
    resultados.Media      = filtroMedia(img);
    resultados.Gauss      = filtroGauss(img);
    resultados.Laplaciano = filtroLaplaciano(img);
    resultados.LoG        = filtroLoG(img);
    resultados.Prewitt    = filtroPrewitt(img);
    resultados.Sobel      = filtroSobel(img);
    resultados.PasaAltos  = filtroPasaAltos(img);
    resultados.HighBoost  = filtroHighBoost(img);
    resultados.DoG        = filtroDoG(img);

    % --- Detección de bordes con 'edge' ---
    resultados.Edge.Sobel   = edge(img, 'sobel');
    resultados.Edge.Prewitt = edge(img, 'prewitt');
    resultados.Edge.Canny   = edge(img, 'canny');
    resultados.Edge.LoG     = edge(img, 'log'); % Laplacian of Gaussian

    % Mostrar comparativa de 'edge'
    figure;
    subplot(3,2,[1 2]), imshow(img,[]), title('Original');
    subplot(3,2,3), imshow(resultados.Edge.Sobel), title('Edge - Sobel');
    subplot(3,2,4), imshow(resultados.Edge.Prewitt), title('Edge - Prewitt');
    subplot(3,2,5), imshow(resultados.Edge.Canny), title('Edge - Canny');
    subplot(3,2,6), imshow(resultados.Edge.LoG), title('Edge - LoG');
end
