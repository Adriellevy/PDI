classdef AortaInfo
    properties
        Nombre   % nombre del archivo DICOM (ej: "21.dcm")
        X        % coordenadas X (columna) de la aorta
        Y        % coordenadas Y (fila)
        Radio    % radios de cada aorta
    end
    
    methods
        function obj = AortaInfo(nombre, X, Y, Radio)
            if nargin > 0
                obj.Nombre = nombre;
                obj.X = Y;
                obj.Y = X;
                obj.Radio = Radio;
            end
        end
        
        function mostrar(obj)
            fprintf('Imagen: %s\n', obj.Nombre);
            for i = 1:length(obj.X)
                fprintf('   Aorta %d: Columna(X)=%d, Fila(Y)=%d, Radio=%.2f\n', ...
                    i, obj.X(i), obj.Y(i), obj.Radio(i));
            end
        end

        function [N, areas_px, areas_mm2, score_total, niveles] = calcularScore(obj, filename)
            % Lee la imagen DICOM y calcula el score de calcio 
            % usando la info de este objeto (centros y radios)
            
            %% 1. Leer imagen y metadatos
            I = double(dicomread(filename));
            info = dicominfo(filename);
            
            % Transformar a Hounsfield Units
            slope = 1; intercept = 0;
            if isfield(info,'RescaleSlope'); slope = info.RescaleSlope; end
            if isfield(info,'RescaleIntercept'); intercept = info.RescaleIntercept; end
            I = I * slope + intercept;
            
            % mm² por píxel
            if isfield(info, 'PixelSpacing')
                pxSpacing = info.PixelSpacing; % [dy, dx] en mm
                obj.Radio=obj.Radio/pxSpacing(1);
                mm_per_pixel = prod(pxSpacing);
            else
                warning('PixelSpacing no encontrado, asumiendo 1 mm²/pixel');
                mm_per_pixel = 1;
            end
            
            %% 2. Crear máscara de las dos aortas
            mask = false(size(I));
            [xx, yy] = meshgrid(1:size(I,2), 1:size(I,1));
            for i = 1:numel(obj.X)
                cx = obj.X(i); % columna
                cy = obj.Y(i); % fila
                r  = obj.Radio(i);
                mask = mask | ((xx - cx).^2 + (yy - cy).^2 <= r^2);
            end

            I_aorta = I .* mask;

            %% 3. Binarizar calcificaciones (HU >= 130)
            calcMask = (I_aorta >= 130);

            % Mostrar para control
            figure; imshow(I, []); hold on;
            viscircles([obj.X(:), obj.Y(:)], obj.Radio(:), 'Color','r');
            plot(obj.X(:), obj.Y(:), 'gx', 'MarkerSize', 10, 'LineWidth', 1.5);
            title(['Detección de calcificaciones - ' obj.Nombre], 'Interpreter','none');

            figure; imshow(calcMask); title('Máscara de calcificaciones');

            %% 4. Etiquetar placas
            CC = bwconncomp(calcMask, 8);
            stats = regionprops(CC, I_aorta, 'Area', 'MaxIntensity');

            N = CC.NumObjects; % cantidad de placas
            areas_px = [stats.Area];
            areas_mm2 = areas_px * mm_per_pixel;

            %% 5. Calcular score Agatston
            niveles = arrayfun(@(s) AortaInfo.asignarNivel(s.MaxIntensity), stats);
            scores = areas_mm2' .* niveles;
            score_total = sum(scores);

            %% 6. Mostrar niveles por placa
            fprintf('\nResultados para %s:\n', obj.Nombre);
            for i = 1:N
                fprintf('   Placa %d: Area = %.1f mm², MaxHU = %.1f, Nivel = %d\n', ...
                    i, areas_mm2(i), stats(i).MaxIntensity, niveles(i));
            end
            fprintf('   Score total = %.1f\n', score_total);
        end
    end
    
    methods (Static)
        function nivel = asignarNivel(maxHU)
            if maxHU >= 130 && maxHU <= 199
                nivel = 1;
            elseif maxHU <= 299
                nivel = 2;
            elseif maxHU <= 399
                nivel = 3;
            else
                nivel = 4;
            end
        end
    end
end
