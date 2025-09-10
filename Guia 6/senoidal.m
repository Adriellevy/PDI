function img = senoidal(M, N, periodos, orientacion)
    [X, Y] = meshgrid(1:N, 1:M);
    switch orientacion
        case 'vertical'
            img = 0.5 + 0.5*sin(2*pi*periodos*X/N);
        case 'horizontal'
            img = 0.5 + 0.5*sin(2*pi*periodos*Y/M);
        otherwise
            error('Orientación inválida: use "vertical" o "horizontal"');
    end
end