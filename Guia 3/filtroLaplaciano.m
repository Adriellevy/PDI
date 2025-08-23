function imgs = filtroLaplaciano(img,idx)
    alphas = [0, 0.5, 1];
    imgs = cell(1,length(alphas));
    if nargin ==1
    figure, subplot(2,2,1), imshow(img), title('Original');
    end
    for i=1:length(alphas)
        h = fspecial('laplacian', alphas(i));
        imgs{i} = filter2(h, img);
        if nargin ==1
        subplot(2,2,i+1), imshow(imgs{i},[]), title(['Laplaciano \alpha=', num2str(alphas(i))]);
        end
    end
    if nargin ==2
        imgs=imgs{idx}
    end
end