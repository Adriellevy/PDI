function filtroEspacialIdeal()
    Lena = imread('lena.png');      % Escala de grises o RGB
    if size(Lena, 3) == 3
        Lena = rgb2gray(Lena);      % Convertir a escala de grises
    end

    Lena = im2double(Lena);
    [h, w] = size(Lena);

    % Submuestreo + sobremuestreo
    Lena32 = Lena(1:4:end, 1:4:end);
    Lena32_upsampled = imresize(Lena32, [h w], 'bilinear');

    % FFT de imagen sobremuestreada
    F = fftshift(fft2(Lena32_upsampled));

    % Crear máscaras circulares
    [X, Y] = meshgrid(1:w, 1:h);
    cx = floor(w/2);
    cy = floor(h/2);
    R = 40;  % Radio de corte (ajustalo según necesidad)

    D = sqrt((X - cx).^2 + (Y - cy).^2);

    % Máscaras
    LP = double(D <= R);  % Paso bajo
    HP = double(D >  R);  % Paso alto

    % Aplicar filtros en frecuencia
    F_LP = F .* LP;
    F_HP = F .* HP;

    % Volver al dominio espacial
    ImagenLP = real(ifft2(ifftshift(F_LP)));
    ImagenHP = real(ifft2(ifftshift(F_HP)));

    % Mostrar
    figure;
    subplot(2,2,1);
    imshow(Lena, []);
    title('1. Imagen original');

    subplot(2,2,2);
    imshow(Lena32_upsampled, []);
    title('2. Submuestreo x32 + interpolación');

    subplot(2,2,3);
    imshow(ImagenLP, []);
    title('3. Filtro Paso Bajo Ideal');

    subplot(2,2,4);
    imshow(ImagenHP + 0.5, []);  % desplazamos para ver zonas negativas
    title('4. Filtro Paso Alto Ideal');
end
