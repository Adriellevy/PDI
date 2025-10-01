function imgs = filtroGauss(img, idx)
    % FILTROGAUSS Aplica distintos filtros gaussianos a una imagen
    % Uso:
    %   imgs = filtroGauss(img)              -> muestra subplots con todos
    %   imgSel = filtroGauss(img, idx)       -> devuelve solo una imagen filtrada (sin subplot)
    %
    % idx puede ser 1, 2 o 3 (según el kernel)

    kernels = {fspecial('gaussian',3,0.5), fspecial('gaussian',5,1), fspecial('gaussian',9,2)};
    imgs = cell(1,length(kernels));
    
    % Caso 1: si no paso idx, muestro todo en subplot
    if nargin < 2
        figure, subplot(2,2,1), imshow(img), title('Original');
        for i=1:length(kernels)
            imgs{i} = filter2(kernels{i}, img);
            subplot(2,2,i+1), imshow(imgs{i},[]), ...
                title(['Gauss ', num2str(size(kernels{i},1)),'x', num2str(size(kernels{i},2))]);
        end
    else
        % Caso 2: si paso un índice, solo devuelvo esa imagen
        if idx < 1 || idx > length(kernels)
            error('El índice debe ser 1, 2 o 3.');
        end
        imgs = filter2(kernels{idx}, img);
    end
end
