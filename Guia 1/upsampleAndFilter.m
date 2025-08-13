% Función para sobremuestrear + filtrar
function img_out = upsampleAndFilter(img_reduced, original_size, filtro)
    % Sobremuestreo (interpolación)
    img_resized = imresize(img_reduced, original_size(1:2), 'bilinear');

    % Aplicar filtro pasa bajos (en cada canal si RGB)
    if size(img_resized, 3) == 3
        img_out = zeros(size(img_resized), 'like', img_resized);
        for c = 1:3
            img_out(:,:,c) = imfilter(img_resized(:,:,c), filtro, 'replicate');
        end
    else
        img_out = imfilter(img_resized, filtro, 'replicate');
    end
end