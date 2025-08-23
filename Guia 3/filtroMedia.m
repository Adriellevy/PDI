function imgs = filtroMedia(img)
    kernels = {fspecial('average',3), fspecial('average',5), fspecial('average',12)};
    imgs = cell(1,length(kernels));
    figure, subplot(2,2,1), imshow(img), title('Original');
    for i=1:length(kernels)
        imgs{i} = filter2(kernels{i}, img);
        subplot(2,2,i+1), imshow(imgs{i},[]), title(['Average ', num2str(size(kernels{i},1)), 'x', num2str(size(kernels{i},2))]);
    end
end