%% =========================
% Función: Transformada de Hough Lineal
% =========================
function applyHoughLines(I, threshold, fillGap, minLength)
    % Convertir a escala de grises si es necesario
    if size(I,3) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    
    % Detección de bordes (Canny funciona bien)
    BW = edge(Igray, 'canny');
    
    % Transformada de Hough
    [H,theta,rho] = hough(BW);
    
    % Buscar picos en la transformada
    peaks = houghpeaks(H, 20, 'Threshold', threshold * max(H(:)));
    
    % Encontrar líneas
    lines = houghlines(BW, theta, rho, peaks, ...
                       'FillGap', fillGap, 'MinLength', minLength);
    
    % Mostrar transformada de Hough con picos
    figure;
    imshow(imadjust(rescale(H)), [], ...
        'XData', theta, 'YData', rho, ...
        'InitialMagnification', 'fit');
    xlabel('\theta (grados)'); ylabel('\rho');
    title('Transformada de Hough');
    axis on, axis normal, hold on;
    plot(theta(peaks(:,2)), rho(peaks(:,1)), 'r*');
    
    % Mostrar líneas sobre la imagen original
    figure, imshow(I), hold on
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
    end
    title('Líneas detectadas con Hough');
    hold off
end
