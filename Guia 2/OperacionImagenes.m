function img_result = OperacionImagenes(img1, img2, tipoOperacion, pesos)
    % OperacionImagenes - Realiza operaciones algebraicas o lógicas sobre dos imágenes.
    %
    % Parámetros:
    % img1, img2: imágenes de entrada (mismo tamaño).
    % tipoOperacion: string indicando la operación ('suma', 'promedio', 'resta', 'multiplicacion', 'and').
    % pesos (opcional): vector de 2 elementos con pesos para el promedio.
    %
    % Retorna:
    % img_result: imagen resultante.

    % Convertir imágenes a double para evitar problemas en operaciones
    img1 = im2double(img1);
    img2 = im2double(img2);

    % Verificar que las imágenes sean del mismo tamaño
    if ~isequal(size(img1), size(img2))
        error('Las imágenes deben tener el mismo tamaño');
    end

    % Seleccionar operación
    switch lower(tipoOperacion)
        case 'suma'
            img_result = img1 + img2;

        case 'promedio'
            if nargin < 4
                % Sin pesos -> promedio simple
                img_result = (img1 + img2) / 2;
            else
                % Promedio ponderado
                if numel(pesos) ~= 2
                    error('El vector de pesos debe tener 2 elementos');
                end
                img_result = (pesos(1)*img1 + pesos(2)*img2) / sum(pesos);
            end

        case 'resta'
            img_result = img1 - img2;

        case 'multiplicacion'
            img_result = img1 .* img2;

        case 'and'
            % Verificar que al menos una imagen sea lógica
            if ~islogical(img1) && ~islogical(img2)
                error('Al menos una de las imágenes debe ser binaria (tipo lógica)');
            end
            img_result = img1 & img2;

        otherwise
            error('Operación no reconocida. Use: suma, promedio, resta, multiplicacion, and');
    end

    % Asegurar que valores estén en rango válido
    img_result = mat2gray(img_result);
end
