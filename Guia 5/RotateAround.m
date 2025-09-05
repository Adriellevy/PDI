function J = RotateAround(I, angle, cx, cy)
    t = affine2d([cosd(angle) sind(angle) 0; ...
                 -sind(angle) cosd(angle) 0; ...
                  0 0 1]);
    % Traslación para que el centro quede fijo
    T1 = affine2d([1 0 0; 0 1 0; -cx -cy 1]);
    T2 = affine2d([1 0 0; 0 1 0; cx cy 1]);
    tform = affine2d(T1.T * t.T * T2.T);
    J = imwarp(I, tform, 'OutputView', imref2d(size(I)));
end