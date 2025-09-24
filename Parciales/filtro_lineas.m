function H = filtro_lineas(M,N,angulos,delta)
    % Filtro que anula líneas en ciertos ángulos en el dominio de Fourier
    % M,N: tamaño
    % angulos: lista de ángulos a eliminar (en grados)
    % delta: ancho de la franja angular
    
    [U,V] = meshgrid(-N/2:N/2-1,-M/2:M/2-1);
    ang = atan2(V,U) * 180/pi; % ángulo en grados
    
    H = ones(M,N);
    for k = 1:length(angulos)
        mask = abs(ang - angulos(k)) <= delta | abs(ang - (angulos(k)-180)) <= delta;
        H(mask) = 0;
    end
end
