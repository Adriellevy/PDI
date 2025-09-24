function H = filtro_lineas(M,N,angulos,delta)
    % Filtro que anula l�neas en ciertos �ngulos en el dominio de Fourier
    % M,N: tama�o
    % angulos: lista de �ngulos a eliminar (en grados)
    % delta: ancho de la franja angular
    
    [U,V] = meshgrid(-N/2:N/2-1,-M/2:M/2-1);
    ang = atan2(V,U) * 180/pi; % �ngulo en grados
    
    H = ones(M,N);
    for k = 1:length(angulos)
        mask = abs(ang - angulos(k)) <= delta | abs(ang - (angulos(k)-180)) <= delta;
        H(mask) = 0;
    end
end
