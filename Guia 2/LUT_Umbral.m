function LUT = LUT_Umbral(umbral)
    in = 0:255;
    LUT = uint8(255 * (in >= umbral));
end
