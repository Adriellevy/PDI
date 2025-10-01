function perim = Ejercicio2(filename)
img = imread(filename);
figure(1)
subplot(1,4,1)
imshow(img)

imgFiltrada = medfilt2(img, [10 10],'symmetric');

imgBin = imbinarize(imgFiltrada);

imgBin = bwmorph(imgBin,'remove');
SE = strel('rectangle',[10 10]);
imgBin = imclose(imgBin,SE);

subplot(1,4,2)
imshow(imgBin)

subplot(1,4,3)
imshow(imgBin)
hold on

[H,theta,rho] = hough(imgBin, 'theta',44:1:46);
peaks  = houghpeaks(H,20);
lines1 = houghlines(imgBin,theta,rho,peaks,'FillGap',100,'MinLength',70);

[H,theta,rho] = hough(imgBin, 'theta',-46:1:-44);
peaks  = houghpeaks(H,20);
lines2 = houghlines(imgBin,theta,rho,peaks,'FillGap',100,'MinLength',70);
lines = [lines1 lines2];

mascara = zeros(size(imgBin));

max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if (len > max_len)
      max_len = len;
      xy_long = xy;
   end   
   
   xy = [lines(k).point1 lines(k).point2];
   mascara = insertShape(mascara, 'Line', xy, 'Color', [1 1 1], 'LineWidth', 2);
   
end

subplot(1,4,4)
imshow(mascara)
hold on
% subplot(1,3,2)
% mascara = imfill(mascara, 'holes');
% imshow(mascara)

mascara = imbinarize(rgb2gray(mascara));
[B,L] = bwboundaries(mascara,'noholes');

for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end
props = regionprops(L, mascara, 'MajorAxisLength');

perim = 0;
for i = 1:length(props)
    perim = perim + props(i).MajorAxisLength;
end
end