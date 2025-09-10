function H = filtro_ideal(M,N,tipo,D0)
    [U,V] = meshgrid(-N/2:N/2-1,-M/2:M/2-1);
    D = sqrt(U.^2 + V.^2);
    switch lower(tipo)
        case 'lowpass'
            H = double(D <= D0);
        case 'highpass'
            H = double(D > D0);
        otherwise
            error('Tipo no válido');
    end
end