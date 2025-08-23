function out = filtroAnisodiff(img, niter, kappa, lambda)
    img = double(img);
    out = img;

    for t = 1:niter
        % Gradientes en 4 direcciones
        nablaN = [diff(out,1,1); zeros(1,size(out,2))];
        nablaS = [zeros(1,size(out,2)); diff(out,1,1)];
        nablaE = [diff(out,1,2), zeros(size(out,1),1)];
        nablaW = [zeros(size(out,1),1), diff(out,1,2)];

        % Coeficientes de conductancia
        cN = exp(-(nablaN/kappa).^2);
        cS = exp(-(nablaS/kappa).^2);
        cE = exp(-(nablaE/kappa).^2);
        cW = exp(-(nablaW/kappa).^2);

        % Actualización
        out = out + lambda*(cN.*nablaN + cS.*nablaS + cE.*nablaE + cW.*nablaW);
    end
end
