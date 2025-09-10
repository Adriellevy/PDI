
function H = filtro_chebyshev(M,N,tipo,D0,n,ripple)
    % Chebyshev tipo I (en freq) - aproximado
    [U,V] = meshgrid(-N/2:N/2-1,-M/2:M/2-1);
    D = sqrt(U.^2 + V.^2);
    epsilon = sqrt(10^(ripple/10)-1);
    switch lower(tipo)
        case 'lowpass'
            x = D./D0;
            H = 1./sqrt(1+(epsilon^2)*cosh(n*acosh(x)).^2);
            H(D<=D0) = 1; % dentro de la banda pasa
        case 'highpass'
            x = D0./D;
            H = 1./sqrt(1+(epsilon^2)*cosh(n*acosh(x)).^2);
            H(D>D0) = 1;
        otherwise
            error('Tipo no válido');
    end
end