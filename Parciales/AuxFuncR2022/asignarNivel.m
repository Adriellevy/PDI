function nivel = asignarNivel(maxHU)
    if maxHU >= 130 && maxHU <= 199
        nivel = 1;
    elseif maxHU <= 299
        nivel = 2;
    elseif maxHU <= 399
        nivel = 3;
    else
        nivel = 4;
    end
end
