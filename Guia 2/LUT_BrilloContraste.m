function LUT = LUT_BrilloContraste(brillo, contraste)
    % brillo: puede ser positivo o negativo
    % contraste: >1 aumenta, <1 disminuye
    in = 0:255;
    out = contraste * (in + brillo);
    % Saturar valores fuera del rango
    out(out > 255) = 255;
    out(out < 0) = 0;
    LUT = uint8(out);
end
