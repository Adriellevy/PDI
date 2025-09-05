function simple_volume_viewer(V, x, y, z)
    % V: volumen 3D
    % x,y,z: vectores de coordenadas
    % -----------------------------------

    % Dimensiones
    nx = length(x);
    ny = length(y);

    % Figura principal
    hFig = figure('Name','Visor Volumétrico','NumberTitle','off','Position',[100 100 1000 500]);

    % Axes para las imágenes
    hAx1 = subplot(1,2,1,'Parent',hFig); % Coronal
    hAx2 = subplot(1,2,2,'Parent',hFig); % Sagital

    % Sliders
    uicontrol('Style','text','String','Coronal (x0)',...
              'Position',[200 20 100 20]);
    hSliderX = uicontrol('Style','slider','Min',1,'Max',nx,'Value',round(nx/2),...
              'Position',[200 0 200 20],...
              'Callback',@updateImages);

    uicontrol('Style','text','String','Sagital (y0)',...
              'Position',[600 20 100 20]);
    hSliderY = uicontrol('Style','slider','Min',1,'Max',ny,'Value',round(ny/2),...
              'Position',[600 0 200 20],...
              'Callback',@updateImages);

    % Dibujar inicial
    updateImages();

    % Función anidada para actualizar
    function updateImages(~,~)
        % Obtener valores actuales de los sliders
        x0 = round(get(hSliderX,'Value'));
        y0 = round(get(hSliderY,'Value'));

        % ---- CORONAL (fijo x) ----
        [Y,Z] = meshgrid(y,z);
        X = x(x0)*ones(size(Y));
        coronal_lin = interp3(x,y,z,V, X,Y,Z,'linear',0);
        coronal_rot = imrotate(coronal_lin',90,'bilinear','loose');

        % Mostrar
        axes(hAx1);
        imshow(coronal_rot,[]);
        title(['Corte sagital en x = ' num2str(x(x0))]);

        % ---- SAGITAL (fijo y) ----
        [X,Z] = meshgrid(x,z);
        Y = y(y0)*ones(size(X));
        sagittal_lin = interp3(x,y,z,V, X,Y,Z,'linear',0);
        sagittal_rot = imrotate(sagittal_lin',90,'bilinear','loose');

        axes(hAx2);
        imshow(sagittal_rot,[]);
        title(['Corte coronal en y = ' num2str(y(y0))]);
    end
end
