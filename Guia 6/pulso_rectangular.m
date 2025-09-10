function img = pulso_rectangular(M, N, ancho, alto)
    [X, Y] = meshgrid(1:N, 1:M);
    cx = N/2; cy = M/2; % centro
    img = (abs(X-cx) <= ancho/2) & (abs(Y-cy) <= alto/2);
end