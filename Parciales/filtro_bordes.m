function BW_edges = filtro_bordes(I, method, seSize)
% preprocessForHough: Preprocesado de imagen para detección de círculos
%
% Sintaxis:
%   BW_edges = preprocessForHough(I, method, seSize)
%
% Entradas:
%   I      : Imagen en escala de grises o binaria.
%   method : 'morph'  -> bordes morfológicos (dilatación - erosión)
%            'canny'  -> detector de Canny
%   seSize : Tamaño del elemento estructurante (ej: 3, 5, 7).
%
% Salida:
%   BW_edges: Imagen binaria de bordes (0-1).
%
% Ejemplo:
%   I = imread('circles.png');
%   BW_edges = preprocessForHough(I, 'morph', 5);
%   imshow(BW_edges);

    % Si es RGB ? gris
    if size(I,3) == 3
        I = rgb2gray(I);
    end

    % Normalizar a double [0,1]
    I = mat2gray(I);

    % Binarizar (umbral automático)
    BW = imbinarize(I);

    % Elemento estructurante
    SE = strel('disk', seSize);

    % Limpieza morfológica básica
    BW_clean = imopen(BW, SE);   % elimina ruido chico
    BW_clean = imclose(BW_clean, SE); % rellena huecos

    % Elección del método de extracción de bordes
    switch lower(method)
        case 'morph'
            % Bordes morfológicos = dilatación - erosión
            dil = imdilate(BW_clean, SE);
            ero = imerode(BW_clean, SE);
            BW_edges = dil - ero;

        case 'canny'
            % Bordes con detector de Canny
            BW_edges = edge(BW_clean, 'canny');

        otherwise
            error('Método no reconocido. Usa "morph" o "canny".');
    end
end
