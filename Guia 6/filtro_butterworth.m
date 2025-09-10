function H = filtro_butterworth(M,N,tipo,D0,n)
    [U,V] = meshgrid(-N/2:N/2-1,-M/2:M/2-1);
    D = sqrt(U.^2 + V.^2);
    switch lower(tipo)
        case 'lowpass'
            H = 1./(1+(D./D0).^(2*n));
        case 'highpass'
            H = 1 - 1./(1+(D./D0).^(2*n));
        otherwise
            error('Tipo no válido');
    end
end