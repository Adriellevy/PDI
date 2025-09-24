function imgTrans=TransformacionIsometrica(img, theta, sx, sy, tx, ty, sentido)
    % TransformacionIsometrica
    % img: matriz de la imagen
    % theta: ángulo en grados
    % sx, sy: factores de escala
    % tx, ty: traslaciones
    % sentido: 'forward' (fuente->destino) o 'inverse' (destino->fuente)

    % Convertir a radianes
    thetaRad = deg2rad(theta);

    % Matriz de transformación homogénea
    T = [ sx*cos(thetaRad), -sy*sin(thetaRad), tx;
          sx*sin(thetaRad),  sy*cos(thetaRad), ty;
          0,                 0,                1 ];

    % Si se pide la transformación inversa
    if strcmpi(sentido, 'inverse')
        T = inv(T);
    end

    % Crear objeto de transformación afín
    tform = affine2d(T');

    % Mantener el tamaño original de la imagen
    outputView = imref2d(size(img));

    % Aplicar transformación
    imgTrans = imwarp(img, tform, 'OutputView', outputView);

    % Mostrar resultados
    figure;
    subplot(1,2,1);
    imshow(img);
    title('Imagen Original');

    subplot(1,2,2);
    imshow(imgTrans);
    title(['Imagen Transformada (' sentido ')']);
end
