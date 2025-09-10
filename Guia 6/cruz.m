function img = cruz(M, N, ancho)
    [X, Y] = meshgrid(1:N, 1:M);
    cx = N/2; cy = M/2;
    vertical = abs(X-cx) <= ancho/2;
    horizontal = abs(Y-cy) <= ancho/2;
    img = vertical | horizontal;
end