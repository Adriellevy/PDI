function imgs = filtroPrewitt(img,idx)
    H = fspecial('prewitt'); V = H';
    imgs = {filter2(H,img), filter2(V,img)};
    if  nargin ==1
        figure;
        subplot(1,3,1), imshow(img,[]), title('Original');
        subplot(1,3,2), imshow(imgs{1},[]), title('Prewitt H');
        subplot(1,3,3), imshow(imgs{2},[]), title('Prewitt V');
    end
    if nargin ==2
        imgs=imgs{idx}
    end
end