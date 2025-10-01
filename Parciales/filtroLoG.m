function imgs = filtroLoG(img,idx)
    params = {[3,0.5],[5,0.3],[9,0.1]};
    imgs = cell(1,length(params));
    if nargin == 1
    figure, subplot(2,2,1), imshow(img), title('Original');
    end
    for i=1:length(params)
        h = fspecial('log', params{i}(1), params{i}(2));
        imgs{i} = filter2(h,img);
        if nargin == 1
        subplot(2,2,i+1), imshow(imgs{i},[]), title(['LoG size=',num2str(params{i}(1)), ', sigma=',num2str(params{i}(2))]);
        end
    end
    % Si el usuario pide un índice → devolver solo esa imagen
    if nargin == 2
        imgs = imgs{idx};
    end
end