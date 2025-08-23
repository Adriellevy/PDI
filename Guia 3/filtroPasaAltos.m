function imgs = filtroPasaAltos(img)
    h_lp = fspecial('average',3);
    h_hp = -h_lp; h_hp(2,2) = h_hp(2,2)+1;
    imgs = {filter2(h_hp,img)};
    figure;
    subplot(1,2,1), imshow(img), title('Original');
    subplot(1,2,2), imshow(imgs{1},[]), title('Pasa-Altos 3x3');
end