function [Hacum, LUT] = LUT_HistogramaAcumulado(img)
    [H, ~] = imhist(img);
    Hacum = cumsum(H) / numel(img);
    LUT = uint8(255 * Hacum);
end