function datosAgrupados = separarInfo(filename)
    % Abrir archivo y leer todo (ignorando encabezado)
    fid = fopen(filename,'r');
    header = fgetl(fid); %#ok<NASGU> % descartar la primera línea (Nombre X Y Radio)
    C = textscan(fid, '%s %f %f %f');
    fclose(fid);

    % Extraer columnas
    nombres = C{1};
    X = C{2};
    Y = C{3};
    R = C{4};

    % Lista de nombres únicos
    unicos = unique(nombres);

    % Prealocar celda para guardar resultados
    datosAgrupados = cell(numel(unicos), 1);

    % Para cada nombre agrupar sus datos (X, Y, Radio)
    for i = 1:numel(unicos)
        idx = strcmp(nombres, unicos{i});
        subData = [X(idx), Y(idx), R(idx)];
        datosAgrupados{i} = subData;
    end
end
