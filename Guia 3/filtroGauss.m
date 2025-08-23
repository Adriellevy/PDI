function imgs = filtroGauss(img)
    kernels = {fspecial('gaussian',3,0.5), fspecial('gaussian',5,1), fspecial('gaussian',9,2)};
    imgs = cell(1,length(kernels));
    figure, subplot(2,2,1), imshow(img), title('Original');
    for i=1:length(kernels)
        imgs{i} = filter2(kernels{i}, img);
        subplot(2,2,i+1), imshow(imgs{i},[]), title(['Gauss ', num2str(size(kernels{i},1)),'x', num2str(size(kernels{i},2))]);
    end
end