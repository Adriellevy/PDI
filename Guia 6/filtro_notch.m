function H = filtro_notch(M,N,u0,v0,r)
    [U,V] = meshgrid(-N/2:N/2-1,-M/2:M/2-1);
    D1 = sqrt((U-u0).^2 + (V-v0).^2);
    D2 = sqrt((U+u0).^2 + (V+v0).^2);
    H = ones(M,N);
    H(D1<=r) = 0;
    H(D2<=r) = 0;
end