function mostrarAortas(filename, centros, radios)
    % filename: ruta al dicom
    % centros: matriz Nx2 [x, y]
    % radios: vector de radios

    % 1. Leer imagen DICOM
    I = dicomread(filename);

    % 2. Mostrar imagen en escala de grises
    figure;
    imshow(I, []);
    hold on;

    % 3. Dibujar círculos de las aortas
    viscircles(centros, radios, 'Color', 'r', 'LineWidth', 0.7);

    % 4. Marcar los centros
    plot(centros(:,1), centros(:,2), 'gx', 'MarkerSize', 10, 'LineWidth', 1.5);

    title(sprintf('Verificación de aortas en %s', filename), 'Interpreter', 'none');
    hold off;
end
