function LUT = LUT_Stretching(p1, p2)
    % p1 y p2: [x, y]
    x1 = p1(1); y1 = p1(2);
    x2 = p2(1); y2 = p2(2);

    in = 0:255;
    LUT = zeros(1,256);

    % Segmento 1
    idx1 = in <= x1;
    LUT(idx1) = y1 / x1 * in(idx1);

    % Segmento 2
    idx2 = (in > x1) & (in <= x2);
    LUT(idx2) = y1 + (y2 - y1)/(x2 - x1) * (in(idx2) - x1);

    % Segmento 3
    idx3 = in > x2;
    LUT(idx3) = y2 + (255 - y2)/(255 - x2) * (in(idx3) - x2);

    LUT(LUT > 255) = 255;
    LUT(LUT < 0) = 0;
    LUT = uint8(LUT);
end
