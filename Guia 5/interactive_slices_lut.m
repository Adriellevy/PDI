function interactive_slices_lut(V, x, y, z)
    % V = volumen 3D
    % x, y, z = vectores de coordenadas
    nx = length(x);
    ny = length(y);
    nz = length(z);

    % Tamaño de la figura
    figWidth = 1000;
    figHeight = 600;
    sliderWidth = 150; % ancho de los sliders
    sliderHeight = 20; % altura de cada slider
    gap = 10;          % separación entre sliders
    leftPanelWidth = sliderWidth + 2*gap;

    % Crear figura
    hFig = figure('Name','Cortes interactivos + LUT','NumberTitle','off','Position',[100 100 figWidth figHeight]);

    % Ejes para imágenes (parte derecha)
    axesWidth = (figWidth - leftPanelWidth - 3*gap)/2;
    axesHeight = figHeight - 150; % dejar espacio para histograma
    hAx1 = axes('Parent',hFig,'Position',[ (leftPanelWidth+2*gap)/figWidth 0.35 axesWidth/figWidth 0.6]); % coronal
    hAx2 = axes('Parent',hFig,'Position',[ (leftPanelWidth+3*gap+axesWidth)/figWidth 0.35 axesWidth/figWidth 0.6]); % sagital

    % Ejes para histograma (abajo)
    hAxHist = axes('Parent',hFig,'Position',[ (leftPanelWidth+gap)/figWidth 0.05 (figWidth-leftPanelWidth-2*gap)/figWidth 0.25]);

    % Sliders y etiquetas en panel izquierdo
    sliderYStart = figHeight - 50;
    
    % CORONAL
    uicontrol('Parent',hFig,'Style','text','Position',[10 sliderYStart sliderWidth sliderHeight],'String','Corte Coronal','BackgroundColor',get(hFig,'Color'));
    hSliderCor = uicontrol('Parent',hFig,'Style','slider','Min',1,'Max',nx,'Value',round(nx/2),'Position',[10 sliderYStart-25 sliderWidth sliderHeight],'Callback',@update_images);

    % SAGITAL
    uicontrol('Parent',hFig,'Style','text','Position',[10 sliderYStart-70 sliderWidth sliderHeight],'String','Corte Sagital','BackgroundColor',get(hFig,'Color'));
    hSliderSag = uicontrol('Parent',hFig,'Style','slider','Min',1,'Max',ny,'Value',round(ny/2),'Position',[10 sliderYStart-95 sliderWidth sliderHeight],'Callback',@update_images);

    % Intensidad mínima
    uicontrol('Parent',hFig,'Style','text','Position',[10 sliderYStart-140 sliderWidth sliderHeight],'String','Intensidad Min','BackgroundColor',get(hFig,'Color'));
    hSliderMin = uicontrol('Parent',hFig,'Style','slider','Min',min(V(:)),'Max',max(V(:)),'Value',min(V(:)),'Position',[10 sliderYStart-165 sliderWidth sliderHeight],'Callback',@update_images);

    % Intensidad máxima
    uicontrol('Parent',hFig,'Style','text','Position',[10 sliderYStart-210 sliderWidth sliderHeight],'String','Intensidad Max','BackgroundColor',get(hFig,'Color'));
    hSliderMax = uicontrol('Parent',hFig,'Style','slider','Min',min(V(:)),'Max',max(V(:)),'Value',max(V(:)),'Position',[10 sliderYStart-235 sliderWidth sliderHeight],'Callback',@update_images);

    % Mostrar imágenes iniciales
    update_images();

    function update_images(~,~)
        % Obtener posiciones de sliders
        x0 = round(get(hSliderCor,'Value'));
        y0 = round(get(hSliderSag,'Value'));
        Imin = get(hSliderMin,'Value');
        Imax = get(hSliderMax,'Value');

        % CORONAL
        [Y,Z] = meshgrid(y,z);
        X = x(x0)*ones(size(Y));
        coronal_lin = interp3(x,y,z,V, X,Y,Z,'linear',0);
        coronal_mask = coronal_lin;
        coronal_mask(coronal_mask<Imin | coronal_mask>Imax) = 0;
        coronal_rot = imrotate(coronal_mask', 90, 'bilinear', 'loose'); % rotación 90°
        axes(hAx1); imshow(coronal_rot,[]); title(['Sagital x=' num2str(x0)]);

        % SAGITAL
        [X,Z] = meshgrid(x,z);
        Y = y(y0)*ones(size(X));
        sagittal_lin = interp3(x,y,z,V, X,Y,Z,'linear',0);
        sagittal_mask = sagittal_lin;
        sagittal_mask(sagittal_mask<Imin | sagittal_mask>Imax) = 0;
        sagittal_rot = imrotate(sagittal_mask', 90, 'bilinear', 'loose'); % rotación 90°
        axes(hAx2); imshow(sagittal_rot,[]); title(['Coronal y=' num2str(y0)]);

        % Histograma
        axes(hAxHist); cla;
        histogram(V(:),100); hold on;
        yL = ylim;
        plot([Imin Imin],[yL(1) yL(2)],'r','LineWidth',2);
        plot([Imax Imax],[yL(1) yL(2)],'r','LineWidth',2);
        title('Histograma del Volumen'); xlabel('Intensidad'); ylabel('Frecuencia');
        hold off;
    end
end
