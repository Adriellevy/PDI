function img = barras(M, N, periodos, orientacion)
    [X, Y] = meshgrid(1:N, 1:M);
    switch orientacion
        case 'vertical'
            img = sin(2*pi*periodos*X/N) > 0;
        case 'horizontal'
            img = sin(2*pi*periodos*Y/M) > 0;
        otherwise
            error('Orientación inválida: use "vertical" o "horizontal"');
    end
end