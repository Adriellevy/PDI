function BW_edges = filtro_bordes(I, method, seSize)
% preprocessForHough: Preprocesado de imagen para detecci�n de c�rculos
%
% Sintaxis:
%   BW_edges = preprocessForHough(I, method, seSize)
%
% Entradas:
%   I      : Imagen en escala de grises o binaria.
%   method : 'morph'  -> bordes morfol�gicos (dilataci�n - erosi�n)
%            'canny'  -> detector de Canny
%   seSize : Tama�o del elemento estructurante (ej: 3, 5, 7).
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

    % Binarizar (umbral autom�tico)
    BW = imbinarize(I);

    % Elemento estructurante
    SE = strel('disk', seSize);

    % Limpieza morfol�gica b�sica
    BW_clean = imopen(BW, SE);   % elimina ruido chico
    BW_clean = imclose(BW_clean, SE); % rellena huecos

    % Elecci�n del m�todo de extracci�n de bordes
    switch lower(method)
        case 'morph'
            % Bordes morfol�gicos = dilataci�n - erosi�n
            dil = imdilate(BW_clean, SE);
            ero = imerode(BW_clean, SE);
            BW_edges = dil - ero;

        case 'canny'
            % Bordes con detector de Canny
            BW_edges = edge(BW_clean, 'canny');

        otherwise
            error('M�todo no reconocido. Usa "morph" o "canny".');
    end
end
