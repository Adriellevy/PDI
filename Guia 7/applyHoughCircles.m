%% =========================
% Función: Transformada de Hough Circular
% =========================
function applyHoughCircles(I, radiusRange, sensitivity, edgeThreshold)
    % Convertir a escala de grises si es necesario
    if size(I,3) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    
    
    % Detectar círculos
    [centers, radii, metric] = imfindcircles(Igray, radiusRange, ...
                        'Sensitivity', sensitivity, ...
                        'EdgeThreshold', edgeThreshold);
    
    % Mostrar resultados
    figure, imshow(I), hold on
    viscircles(centers, radii, 'EdgeColor', 'b');
    title('Círculos detectados con Hough circular');
    
    % Mostrar información de retorno
    disp('Centers (x,y):'); disp(centers);
    disp('Radii:'); disp(radii);
    disp('Metric (confianza):'); disp(metric);
end
