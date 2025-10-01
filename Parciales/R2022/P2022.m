% Nombre	X	Y	Radio   Info para este ejemplo
% 21.dcm	221	164	18.55
% 21.dcm	378	226	17.09
% 23.dcm	217	154	18.55
% 23.dcm	382	226	17.09

% --- Lectura y conversion a HU ---
I_raw = dicomread('IM-0269-0021.dcm');
Info  = dicominfo('IM-0269-0021.dcm');

HU = double(I_raw);
if isfield(Info,'RescaleSlope') && isfield(Info,'RescaleIntercept')
    HU = HU * Info.RescaleSlope + Info.RescaleIntercept;
end

ps = [1 1];
if isfield(Info,'PixelSpacing')
    ps = Info.PixelSpacing;    % [mm_row, mm_col] normalmente
end
area_pixel_mm2 = ps(1)*ps(2);

% --- Parámetros (ajustá si querés) ---
pad_mm    = 10;  % padding alrededor del vaso en mm
w_in_mm   = 5;   % ancho interno del anillo (desde radio hacia dentro)
w_out_mm  = 5;   % ancho externo del anillo (desde radio hacia fuera)
min_area_mm2 = 1.0;   % criterio Agatston

% convertir mm a píxeles
pad_px   = ceil(pad_mm / ps(1));
w_in_px  = ceil(w_in_mm / ps(1));
w_out_px = ceil(w_out_mm / ps(1));
min_area_px = ceil(min_area_mm2 / area_pixel_mm2);

% aorta ascendente y descendente
cx_asc = 164; cy_asc = 221; r_asc = 18.55/ps(1) * 1; 
cx_desc = 226; cy_desc = 378; r_desc = 17.09/ps(1) * 1;
centers = [cx_asc cy_asc r_asc; cx_desc cy_desc r_desc];

nAortas = size(centers,1);
MaskAorta = false([size(HU), nAortas]);

[X,Y] = meshgrid(1:size(HU,2), 1:size(HU,1));

for a = 1:nAortas
    cx = centers(a,1);
    cy = centers(a,2);
    r  = centers(a,3);

    tempMask = (X-cx).^2 + (Y-cy).^2 <= r^2;
    MaskAorta(:,:,a) = tempMask;
end

% aplicar máscara
AortaSeg = HU .* any(MaskAorta,3);

% mostrar
figure;
subplot(1,2,1), imshow(HU, []), title('Original');
subplot(1,2,2), imshow(AortaSeg, []), title('Sólo Aortas');




% --- Umbral para calcio ---
HU_thresh = 130; % HU mínimo para considerar calcio

% Máscara de candidatos a calcio
MaskCalcio = (AortaSeg > HU_thresh);

% Etiquetar regiones conectadas (cada placa)
CC = bwconncomp(MaskCalcio);

% Medidas de cada componente
Stats = regionprops(CC, AortaSeg, 'Area', 'MaxIntensity');

ScorePlacas = zeros(CC.NumObjects,1);
Area_total = 0;
for i = 1:CC.NumObjects
    area_px = Stats(i).Area;
    area_mm2 = area_px * area_pixel_mm2;

    if area_mm2 >= min_area_mm2
        % Nivel según HU máximo de la placa
        HUmax = Stats(i).MaxIntensity;
        if HUmax >= 130 && HUmax < 200
            nivel = 1;
        elseif HUmax >= 200 && HUmax < 300
            nivel = 2;
        elseif HUmax >= 300 && HUmax < 400
            nivel = 3;
        else
            nivel = 4;
        end

        % Score Agatston de la placa
        ScorePlacas(i) = area_mm2 * nivel;
        Area_total = Area_total + area_mm2;
    end
end

% Score total del paciente
ScoreTotal = sum(ScorePlacas);

% --- Mostrar resultados ---
fprintf('Score total Agatston: %.2f\n', ScoreTotal);

for i = 1:CC.NumObjects
    if ScorePlacas(i) > 0
        fprintf('Placa %d: Area=%.2f mm2, Score=%.2f\n', ...
            i, Stats(i).Area * area_pixel_mm2, ScorePlacas(i));
    end
end

% Visualización: Placas sobre la imagen
figure;
imshow(HU, []); hold on;
for i = 1:CC.NumObjects
    if ScorePlacas(i) > 0
        % Dibujo contorno de la placa
        pixelIdxList = CC.PixelIdxList{i};
        [r,c] = ind2sub(size(HU), pixelIdxList);
        plot(c, r, 'r.', 'MarkerSize', 5);
    end
end
title(sprintf('Score total Agatston = %.2f', ScoreTotal));
