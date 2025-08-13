function [out, LUT] = crearVentana(center, width, min_val, max_val)
    in = min_val:max_val;
    low = center - width/2;
    high = center + width/2;
    LUT = uint8(255 * (in - low) / (high - low));
    LUT(in <= low) = 0;
    LUT(in >= high) = 255;
    out = LUT;
end