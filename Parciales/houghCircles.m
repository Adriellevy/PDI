function [centers, radii, accumulator] = houghCirclesBW(BW, rRange, numPeaks)
% houghCirclesBW: Detecci�n de c�rculos con transformada de Hough
% a partir de una imagen binaria (bordes ya detectados).
%
% Sintaxis:
%   [centers, radii, accumulator] = houghCirclesBW(BW, rRange, numPeaks)
%
% Entradas:
%   BW       : Imagen binaria (bordes = 1, fondo = 0).
%   rRange   : [rMin rMax], rango de radios en pixeles.
%   numPeaks : N�mero m�ximo de c�rculos a devolver.
%
% Salidas:
%   centers    : Coordenadas (x,y) de los centros detectados.
%   radii      : Radios correspondientes.
%   accumulator: Espacio de acumulaci�n (3D: filas, cols, radios).
%
% Ejemplo:
%   BW = imread('circlesEdges.png'); % imagen binaria
%   [centers, radii] = houghCirclesBW(BW, [15 40], 5);
%   imshow(BW); hold on;
%   viscircles(centers, radii, 'EdgeColor','r');

    % Asegurarse de que sea binaria l�gica
    BW = logical(BW);

    [rows, cols] = size(BW);
    rMin = rRange(1);
    rMax = rRange(2);

    % Inicializar acumulador
    accumulator = zeros(rows, cols, rMax);

    % Coordenadas de p�xeles de borde
    [yIdx, xIdx] = find(BW);

    % Transformada de Hough
    for r = rMin:rMax
        for k = 1:length(xIdx)
            x = xIdx(k);
            y = yIdx(k);

            for theta = 0:pi/8:2*pi
                a = round(x - r*cos(theta));
                b = round(y - r*sin(theta));

                if a > 0 && a <= cols && b > 0 && b <= rows
                    accumulator(b, a, r) = accumulator(b, a, r) + 1;
                end
            end
        end
    end

    % Buscar m�ximos locales en la proyecci�n 2D
    acc2D = max(accumulator, [], 3);
    peaks = imregionalmax(acc2D);

    % Ordenar por intensidad
    [py, px] = find(peaks);
    values = acc2D(peaks);

    [~, idx] = sort(values, 'descend');
    idx = idx(1:min(numPeaks, length(idx)));

    centers = [px(idx), py(idx)];
    radii   = zeros(length(idx),1);

    % Elegir radio m�s votado por cada centro
    for i = 1:length(idx)
        x0 = px(idx(i));
        y0 = py(idx(i));
        [~, rBest] = max(squeeze(accumulator(y0, x0, :)));
        radii(i) = rBest;
    end
end
