
I =imread('circles.png');

se = strel('disk',6);

figure;
subplot(2,3,1), imshow(imdilate(I,se)), title('Dilataci�n');
subplot(2,3,2), imshow(imerode(I,se)), title('Erosi�n');
subplot(2,3,3), imshow(imclose(I,se)), title('Cierre');
subplot(2,3,4), imshow(bwmorph(I,'thin',Inf)), title('Adelgazamiento');
subplot(2,3,5), imshow(bwmorph(I,'skel',Inf)), title('Esqueletonizaci�n');
subplot(2,3,6), imshow(bwmorph(I,'spur',5)), title('Poda (Spur)');