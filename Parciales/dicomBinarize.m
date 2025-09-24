function BW = dicomBinarize(I, windowWidth, windowCenter, invert)
% dicomBinarize: Binariza una imagen DICOM en base a ancho de ventana y centro.
%
% Sintaxis:
%   BW = dicomBinarize(I, windowWidth, windowCenter, invert)
%
% Entradas:
%   I             : Imagen DICOM (matriz 2D, preferentemente int16 o double).
%   windowWidth   : Ancho de la ventana (W).
%   windowCenter  : Centro de la ventana (C).
%   invert        : 0 = normal, 1 = invertido.
%
% Salida:
%   BW            : Imagen binaria (double con valores 0 y 1).
%
% Ejemplo:
%   I = dicomread('archivo.dcm');
%   BW = dicomBinarize(I, 400, 40, 0);
%   imshow(BW);

    % Convertir a double para operaciones seguras
    I = double(I);

    % Límites de la ventana
    lowerBound = windowCenter - windowWidth/2;
    upperBound = windowCenter + windowWidth/2;

    % Binarización
    if invert == 0
        BW = (I >= lowerBound) & (I <= upperBound);
    else
        BW = (I < lowerBound) | (I > upperBound);
    end

    % Convertir a double para que imshow lo interprete como 0-1
    BW = double(BW);
end
