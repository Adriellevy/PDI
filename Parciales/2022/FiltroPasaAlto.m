function H = FiltroPasaAlto(img,fc)
  radio = fc;

  [W,H,c] = size(img);
  x = 1:H;
  y = 1:W;
  x0 = H/2;
  y0 = W/2;

  [X,Y] = meshgrid(x,y);
  H =(X-x0).^2 + (Y-y0).^2 > radio^2;
end