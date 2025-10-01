function [N, areas_px, areas_mm2, score_total] = P2022(filename, radios, centros)
    % filename: string con ruta a imagen DICOM
    % radios: [r1, r2] radio ascendente y descendente
    % centros: [x1 y1; x2 y2] centros (ascendente, descendente)

    %% 1. Leer imagen DICOM y metadatos
    I = double(dicomread(filename));
    info = dicominfo(filename);

    % PixelSpacing (mm por pixel en fila y columna)
    if isfield(info, 'PixelSpacing')
        pxSpacing = info.PixelSpacing; % [dy, dx] en mm
        mm_per_pixel = prod(pxSpacing); % área por píxel en mm²
    else
        warning('PixelSpacing no encontrado en metadatos, asumiendo 1 mm²/pixel');
        mm_per_pixel = 1;
    end

    %% 2. Crear máscara de las dos aortas
    mask = false(size(I));
    [xx, yy] = meshgrid(1:size(I,2), 1:size(I,1));

    for i = 1:2
        cx = centros(i,1);
        cy = centros(i,2);
        r  = radios(i);
        mask = mask | ((xx-cx).^2 + (yy-cy).^2 <= r^2);
    end

    I_aorta = I .* mask; % extraer solo la aorta

    %% 3. Binarizar calcificaciones (HU >= 130)
    calcMask = (I_aorta >= 130);

    %% 4. Etiquetar placas y medir propiedades
    CC = bwconncomp(calcMask, 8); % componentes conectados
    stats = regionprops(CC, I_aorta, 'Area', 'MaxIntensity');

    N = CC.NumObjects; % cantidad de placas
    areas_px = [stats.Area]; % en píxeles
    areas_mm2 = areas_px * mm_per_pixel; % en mm²

    %% 5. Score Agatston
    niveles = arrayfun(@(s) asignarNivel(s.MaxIntensity), stats);
    scores = areas_mm2 .* niveles;
    score_total = sum(scores);
end
