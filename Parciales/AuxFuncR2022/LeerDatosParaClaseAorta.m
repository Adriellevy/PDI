function objetos = LeerDatosParaClaseAorta(filename)
    % Abrir archivo
    fid = fopen(filename, 'r');
    if fid == -1
        error('No se pudo abrir el archivo: %s', filename);
    end

    % Saltar encabezado
    fgetl(fid);

    % Leer datos
    C = textscan(fid, '%s %f %f %f');
    fclose(fid);

    nombres = C{1};
    X = C{2};
    Y = C{3};
    R = C{4};

    % Nombres únicos
    unicos = unique(nombres);

    % Crear objetos
    objetos = AortaInfo.empty;
    for i = 1:numel(unicos)
        idx = strcmp(nombres, unicos{i});
        objetos(i) = AortaInfo(unicos{i}, X(idx)', Y(idx)', R(idx)');
    end
end
