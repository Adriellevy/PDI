function imgs = filtroDoG(img, idx)
    % Definimos pares de sigmas (sigma1 < sigma2)
    sigmas = {[1,2], [1,4], [2,5]};
    imgs = cell(1, length(sigmas));

    figure, subplot(2,2,1), imshow(img,[]), title('Original');
    for i = 1:length(sigmas)
        g1 = fspecial('gaussian', 9, sigmas{i}(1));
        g2 = fspecial('gaussian', 9, sigmas{i}(2));
        imf1 = filter2(g1, img);
        imf2 = filter2(g2, img);
        imgs{i} = imf1 - imf2; % diferencia = DoG
        subplot(2,2,i+1), imshow(imgs{i},[]), ...
            title(['DoG \sigma_1=', num2str(sigmas{i}(1)), ', \sigma_2=', num2str(sigmas{i}(2))]);
    end

    % Si el usuario pide un índice → devolver solo esa imagen
    if nargin == 2
        imgs = imgs{idx};
    end
end
