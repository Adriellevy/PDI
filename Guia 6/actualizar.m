function actualizar(I, Fshift, M, N, slider_h, slider_v)
    % Leer valores actuales de los sliders
    ancho_h = round(get(slider_h,'Value'));
    ancho_v = round(get(slider_v,'Value'));

    cx = N/2; cy = M/2;

    % --- Filtro horizontal ---
    mask_h = zeros(M,N);
    mask_h(:, max(1,cx-ancho_h):min(N,cx+ancho_h)) = 1;
    Ih = ifft2(ifftshift(Fshift .* mask_h));

    % --- Filtro vertical ---
    mask_v = zeros(M,N);
    mask_v(max(1,cy-ancho_v):min(M,cy+ancho_v), :) = 1;
    Iv = ifft2(ifftshift(Fshift .* mask_v));

    % --- Suma de filtros ---
    Ihv = Ih + Iv;

    % --- Actualizar plots ---
    subplot(2,2,1); imshow(I, []); title('Imagen original');
    subplot(2,2,2); imshow(abs(Ih), []); title(['Filtro Horizontal (ancho=' num2str(ancho_h) ')']);
    subplot(2,2,4); imshow(abs(Iv), []); title(['Filtro Vertical (ancho=' num2str(ancho_v) ')']);
    subplot(2,2,3); imshow(Ihv, []); title('Suma de Filtros');
end