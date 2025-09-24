function actualizar(slider,I,ax1,ax2)
    ang = get(slider,'Value');
    I_rot = imrotate(I, ang, 'bilinear','crop');

    % --- Reaplicar Transformada de Hotelling ---
    [rows, cols] = size(I_rot);
    [x, y] = meshgrid(1:cols, 1:rows);
    m_x = sum(sum(x .* I_rot)) / sum(I_rot(:));
    m_y = sum(sum(y .* I_rot)) / sum(I_rot(:));
    Qxx = sum(sum(((x - m_x).^2) .* I_rot)) / sum(I_rot(:));
    Qyy = sum(sum(((y - m_y).^2) .* I_rot)) / sum(I_rot(:));
    Qxy = sum(sum(((x - m_x).*(y - m_y)) .* I_rot)) / sum(I_rot(:));
    Q = [Qxx Qxy; Qxy Qyy];

    [V,D] = eig(Q);
    [~,idx] = max(diag(D));
    pc1 = V(:,idx);
    theta = atan2(pc1(2), pc1(1)) * 180/pi;

    I_corr = imrotate(I_rot, -theta, 'bilinear','crop');

    % Actualizar imágenes
    axes(ax1); imshow(I_rot); title(['Imagen Rotada: ' num2str(round(ang)) '°']);
    axes(ax2); imshow(I_corr); title('Imagen Corregida (PCA)');
end
