function img_result = PromedioImagenes(listaImagenes, pesos)
    % PromedioImagenes - Calcula el promedio (simple o ponderado) de N imágenes
    %
    % listaImagenes: cell array de imágenes (todas del mismo tamaño)
    % pesos: vector de pesos (opcional). Si no se pasa, se hace promedio simple.
    %
    % Ejemplo:
    % imgs = {imread('img1.png'), imread('img2.png'), imread('img3.png')};
    % resultado = PromedioImagenes(imgs, [0.5 0.3 0.2]);
    %
    % Retorna:
    % img_result: imagen promedio.

    N = numel(listaImagenes);

    if N < 2
        error('Debe haber al menos dos imágenes para promediar.');
    end

    % Convertir todas las imágenes a double y verificar tamaño
    for i = 1:N
        listaImagenes{i} = im2double(listaImagenes{i});
        if i > 1 && ~isequal(size(listaImagenes{i}), size(listaImagenes{1}))
            error('Todas las imágenes deben tener el mismo tamaño.');
        end
    end

    % Si no se pasan pesos, usar promedio simple
    if nargin < 2
        pesos = ones(1, N) / N;
    else
        if numel(pesos) ~= N
            error('El número de pesos debe coincidir con el número de imágenes.');
        end
        pesos = pesos / sum(pesos); % normalizar
    end

    % Calcular promedio ponderado
    img_result = zeros(size(listaImagenes{1}));
    for i = 1:N
        img_result = img_result + pesos(i) * listaImagenes{i};
    end

    % Normalizar resultado a rango [0,1]
    img_result = mat2gray(img_result);
end
