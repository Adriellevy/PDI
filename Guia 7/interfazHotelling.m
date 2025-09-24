function interfazHotelling(I)
    % Crear ventana
    f = figure('Name','Transformada de Hotelling - Rotaciones',...
               'NumberTitle','off','Position',[200 200 800 400]);

    % Imagen original
    ax1 = subplot(1,2,1); imshow(I); title('Imagen Rotada Manual');
    ax2 = subplot(1,2,2); imshow(I); title('Imagen Alineada (PCA)');

    % Slider para ángulo de rotación
    uicontrol('Style','text','Position',[300 20 200 20],...
              'String','Ángulo de rotación (°)');
    slider = uicontrol('Style','slider','Min',0,'Max',180,'Value',0,...
                       'Position',[250 50 300 20],...
                       'Callback',@(src,~) actualizar(src,I,ax1,ax2));
end