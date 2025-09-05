%% Traslación circular
function J = circularShift(I, shiftVec)
    J = circshift(I, shiftVec);
end