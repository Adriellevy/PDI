%% Escalado desde centro
function J = scaleFromCenter(I, scale, method)
    if nargin<3, method='nearest'; end
    cx = size(I,2)/2; cy = size(I,1)/2;
    T1 = affine2d([1 0 0; 0 1 0; -cx -cy 1]);
    S  = affine2d([scale 0 0; 0 scale 0; 0 0 1]);
    T2 = affine2d([1 0 0; 0 1 0; cx cy 1]);
    tform = affine2d(T1.T * S.T * T2.T);
    J = imwarp(I, tform, 'OutputView', imref2d(size(I)), 'InterpolationMethod', method);
end