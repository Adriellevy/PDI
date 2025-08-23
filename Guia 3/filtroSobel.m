function imgs = filtroSobel(img)
    H = fspecial('sobel'); V = H';
    imgs = {filter2(H,img), filter2(V,img)};
    figure;
    subplot(1,3,1), imshow(img), title('Original');
    subplot(1,3,2), imshow(imgs{1},[]), title('Sobel H');
    subplot(1,3,3), imshow(imgs{2},[]), title('Sobel V');
end