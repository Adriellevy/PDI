function img_out = AplicarLUT(img_in, LUT)
    % AplicarLUT - Aplica una tabla de búsqueda (LUT) a una imagen en escala de grises
    %
    % Sintaxis:
    %   img_out = AplicarLUT(img_in, LUT)
    %
    % Entradas:
    %   img_in : matriz de la imagen en escala de grises (uint8 o double)
    %   LUT    : vector fila o columna con 256 elementos, valores en [0,255]
    %
    % Salidas:
    %   img_out : imagen transformada según la LUT

    % Verificar que la LUT tenga 256 elementos
    if numel(LUT) ~= 256
        error('La LUT debe contener exactamente 256 elementos.');
    end

    % Asegurar que la imagen sea de tipo uint8 para indexar
    if ~isa(img_in, 'uint8')
        img_in = im2uint8(img_in);
    end

    % Asegurar que la LUT sea uint8
    LUT = uint8(LUT(:)); % convertir a columna uint8

    % Aplicar la LUT
    img_out = LUT(double(img_in) + 1); 
    % "+1" porque en MATLAB los índices empiezan en 1, pero los niveles de gris empiezan en 0

end
