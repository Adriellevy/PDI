function img = circulo_centrado(M, N, radio)
    [X, Y] = meshgrid(1:N, 1:M);
    cx = N/2; cy = M/2;
    img = ((X-cx).^2 + (Y-cy).^2) <= radio^2;
end