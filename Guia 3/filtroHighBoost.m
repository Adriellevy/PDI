function imgs = filtroHighBoost(img)
    A_values = [1,2,8];
    h_lp = fspecial('average',3);
    imgs = cell(1,length(A_values));
    figure, subplot(2,2,1), imshow(img,[]), title('Original');
    for k=1:length(A_values)
        h_hb = -h_lp; h_hb(2,2) = h_hb(2,2)+A_values(k);
        imgs{k} = filter2(h_hb,img);
        subplot(2,2,k+1), imshow(imgs{k},[]), title(['High-Boost A=',num2str(A_values(k))]);
    end
end