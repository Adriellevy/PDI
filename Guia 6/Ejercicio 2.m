% Ejercicio 2.m
% Script para realizar la consignas de Transformada Discreta de Fourier
% sobre las im�genes sint�ticas del ejercicio anterior.

close all; clear; clc;

%% ---------------------------
% 1) Generar imagen: pulso rectangular (por defecto 256x256)
M = 256; N = 256;
ancho = 80; alto = 40;
img_pulso = pulso_rectangular(M, N, ancho, alto);    % binaria

% Guardamos tambi�n otras sintetizadas para inciso b
img_circulo = circulo_centrado(M, N, 60);
img_cruz = cruz(M, N, 5);
img_barras_v = double(barras(M, N, 6, 'vertical'));      % {0,1}
img_barras_h = double(barras(M, N, 6, 'horizontal'));
img_sen_v = senoidal(M, N, 6, 'vertical');               % [0,1]
img_sen_h = senoidal(M, N, 6, 'horizontal');

%% ---------------------------
% UTILIDADES (subfunciones definidas al final del archivo)

%% ===========================
% a) FFT del pulso rectangular y gr�fico del m�dulo.
%    Probar fftshift y LUT logar�tmica.
% ===========================
F = fft2(double(img_pulso));            % FFT 2D
Fshift = fftshift(F);                   % centrado espectro
modF = abs(F);                          % m�dulo sin shift
modFshift = abs(Fshift);                % m�dulo con shift (centro en medio)

% Mostrar: m�dulo lineal y log LUT
figure('Name','Pulso rectangular - FFT');
subplot(2,2,1), imagesc(modF), axis image off, title('M�dulo |F| (sin shift)');
subplot(2,2,2), imagesc(modFshift), axis image off, title('M�dulo |F| (fftshift)');
subplot(2,2,3), imagesc(log(1+modF)), axis image off, title('log(1+|F|) (sin shift)');
subplot(2,2,4), imagesc(log(1+modFshift)), axis image off, title('log(1+|F|) (fftshift)');
colormap gray;

% Comentario r�pido:
% En teor�a, la FFT de un pulso rectangular produce un sinc (separable) en
% frecuencia. Con fftshift aparece el l�bulo principal centrado y l�bulos
% laterales (patr�n sinc). La LUT logar�tmica permite ver mejor los l�bulos.

%% ===========================
% b) FFT de las im�genes sintetizadas - graficar m�dulo y fase.
%    Realizar transformaciones geom�tricas y verificar propiedades.
% ===========================
sinteticas = {img_pulso, img_circulo, img_cruz, img_barras_v, img_sen_v};
n = numel(sinteticas);
figure('Name','M�dulo y fase de im�genes sintetizadas','Position',[100 100 1200 800]);
for k=1:n
    I = double(sinteticas{k});
    Fk = fft2(I);
    FkS = fftshift(Fk);
    modk = log(1+abs(FkS));
    phk = angle(FkS);                      % fase en [-pi, pi]

    subplot(n,2,2*(k-1)+1), imagesc(modk), axis image off;
    title(sprintf('Log m�dulo (img %d)',k));
    subplot(n,2,2*(k-1)+2), imagesc(phk), axis image off; colorbar;
    title(sprintf('Fase (img %d)',k));
end
colormap gray;

% b.i) Transformaciones geom�tricas: traslaci�n, escalado, rotaci�n
I0 = img_circulo; % usamos c�rculo para ver efectos
% Traslaci�n: circular -> equivalente a fase lineal en F
I_trans = circshift(I0, [30, 50]);      % desplaza 30 filas, 50 columnas
% Escalado (interpolaci�n) -> cambio en la distribuci�n de espectro
I_scale = imresize(I0, 0.7, 'bilinear'); 
I_scale = imresize(I_scale, [M N]);     % volver a MxN para comparar
% Rotaci�n
I_rot = imrotate(I0, 30, 'bilinear', 'crop');

% FFTs
F0 = fftshift(fft2(double(I0)));
Ft = fftshift(fft2(double(I_trans)));
Fs = fftshift(fft2(double(I_scale)));
Fr = fftshift(fft2(double(I_rot)));

figure('Name','Transformaciones geom�tricas y sus FFTs');
subplot(4,4,1), imshow(I0), title('Original'); subplot(4,4,2), imagesc(log(1+abs(F0))), axis image off, title('Log|F original)');
subplot(4,4,3), imshow(I_trans), title('Trasladada (circshift)');
subplot(4,4,4), imagesc(log(1+abs(Ft))), axis image off, title('Log|F trasl.');
subplot(4,4,5), imshow(I_scale), title('Escalada (resize)');
subplot(4,4,6), imagesc(log(1+abs(Fs))), axis image off, title('Log|F escala)');
subplot(4,4,7), imshow(I_rot), title('Rotada (30�)');
subplot(4,4,8), imagesc(log(1+abs(Fr))), axis image off, title('Log|F rotada)');
colormap gray;

% Observaciones (te�ricas):
% - Traslaci�n en el dominio espacial -> multiplica F por una fase lineal; el
%   m�dulo de F no cambia (solo la fase). Por eso log|F| similar para I0 y I_trans.
% - Escalado espacial -> compresi�n/expansi�n en frecuencia (altera la densidad
%   de periodos). Un objeto escalado produce un espectro que se "estira".
% - Rotaci�n espacial -> rotaci�n igual del espectro (m�dulo rotado).

% b.ii) �Qu� se observa al variar la frecuencia de las senoidales?
freqs = [2, 6, 16];
figure('Name','Senoidales: variando frecuencia');
for i=1:length(freqs)
    f = freqs(i);
    S = senoidal(M, N, f, 'vertical');
    F = fftshift(fft2(S));
    subplot(1,3,i), imagesc(log(1+abs(F))), axis image off, title(sprintf('%d per. verticales',f));
end
colormap gray;
% Observaci�n: al aumentar la frecuencia aparecen picos en el dominio de
% frecuencia m�s alejados del origen; patr�n m�s denso (m�s arm�nicos).

%% ===========================
% c) FFT de un pulso rectangular. Antitransformar: �se recupera exactamente?
%    Experimento con escalas grandes (1e15..1e20) para ver errores num�ricos.
% ===========================
Iorig = double(img_pulso);
F = fft2(Iorig);
Irec = real(ifft2(F));             % reconstructor directo
err_direct_max = max(abs(Iorig(:)-Irec(:)));
err_direct_rmse = sqrt(mean((Iorig(:)-Irec(:)).^2));

% Experimento de escalado
scales = [1e6, 1e10, 1e15, 1e18, 1e20];
errs = zeros(length(scales),2);
for k=1:length(scales)
    s = scales(k);
    % multiplicamos la imagen por s, calculamos FFT y luego ifft y dividimos
    Fscl = fft2(Iorig * s);
    Iscl_rec = real(ifft2(Fscl)) / s;
    errs(k,1) = max(abs(Iorig(:)-Iscl_rec(:)));
    errs(k,2) = sqrt(mean((Iorig(:)-Iscl_rec(:)).^2));
end

% Mostrar resultados
fprintf('Recuperaci�n directa: max err = %.3e, RMSE = %.3e\n', err_direct_max, err_direct_rmse);
for k=1:length(scales)
    fprintf('Scale %.0e -> max err = %.3e, RMSE = %.3e\n', scales(k), errs(k,1), errs(k,2));
end

% Comentario:
% - En precisi�n doble (double) la IFFT(FFT(I)) recupera la imagen con errores ~1e-16..1e-15.
% - Si multiplic�s por escalas gigantes (p. ej. 1e20) se pueden introducir
%   errores por saturaci�n/precisi�n de punto flotante, y la recuperaci�n
%   ya no es exacta; por eso el enunciado sugiere probar escalas entre 1e15-1e20
%   para ilustrar p�rdidas num�ricas.

%% ===========================
% d) FFT de una imagen -> quedarnos con fase (anular m�dulo) y antitransformar.
%    Repetir anulando la fase (conservar m�dulo).
% ===========================
I = double(imread('cameraman.tif')); % imagen de ejemplo en MATLAB (grises)
I = im2double(imresize(I, [M N]));   % ajustar tama�o MxN

F = fft2(I);
Fshift = fftshift(F);

% 1) Anular m�dulo, conservar fase: a menudo se normaliza m�dulo a 1 y se usa la fase
phase = angle(F);
% reconstruir con m�dulo unitario:
F_phaseOnly = exp(1i * phase);
I_phaseOnly = real(ifft2(F_phaseOnly));

% 2) Anular fase (poner fase cero), conservar m�dulo:
mag = abs(F);
F_magOnly = mag; % + 0i (fase=0)
I_magOnly = real(ifft2(F_magOnly));

% 3) Alternativa com�n: fijar m�dulo = 1 (no 0), para ver efecto de la fase m�s claro:
F_unitMag = abs(F) > 0; % ones en posiciones no-cero
F_unitMag = F_unitMag .* exp(1i * phase);
I_unitMag = real(ifft2(F_unitMag));

% Mostrar resultados
figure('Name','Conservar fase vs conservar m�dulo');
subplot(2,3,1), imshow(I,[]), title('Original (cameraman)');
subplot(2,3,2), imshow(mat2gray(I_phaseOnly)), title('Reconstrucci�n: s�lo fase (m�dulo=1)');
subplot(2,3,3), imshow(mat2gray(I_unitMag)), title('S�lo fase (m�dulo=1 en no-cero)');
subplot(2,3,4), imshow(mat2gray(abs(I_magOnly))), title('Reconstrucci�n: s�lo m�dulo (fase=0)');
subplot(2,3,5), imagesc(log(1+abs(fftshift(F)))), axis image off, title('Log|F| original');
colormap gray;

% Observaciones:
% - Conservar SOLO la fase (normalizando el m�dulo) produce una imagen que
%   conserva casi toda la estructura y bordes: la fase contiene la mayor parte
%   de la informaci�n perceptual/estructural.
% - Conservar SOLO el m�dulo y fijar fase = 0 produce una imagen que es
%   generalmente sin forma reconocible (textura/smoothing). La informaci�n
%   espacial fina se pierde.

%% ===========================
% e) FFT de dos fotograf�as en grises: intercambiar m�dulo y antitransformar.
%    Comparar cu�l reconstrucci�n se parece m�s al original (fase vs m�dulo).
% ===========================
% Usamos dos im�genes de ejemplo: cameraman y coins (ambas incluidas en MATLAB)
A = im2double(imresize(imread('cameraman.tif'), [M N]));
B = im2double(imresize(imread('coins.png'), [M N]));

FA = fft2(A); FB = fft2(B);
magA = abs(FA); phA = angle(FA);
magB = abs(FB); phB = angle(FB);

% Swap: m�dulo A + fase B ; m�dulo B + fase A
C1 = real(ifft2( magA .* exp(1i*phB) ));   % m�dulo A + fase B
C2 = real(ifft2( magB .* exp(1i*phA) ));   % m�dulo B + fase A

% Mostrar
figure('Name','Intercambio de m�dulo y fase entre 2 im�genes');
subplot(2,3,1), imshow(A,[]), title('Imagen A (cameraman)');
subplot(2,3,2), imshow(B,[]), title('Imagen B (coins)');
subplot(2,3,3), imshow(mat2gray(C1)), title('m�dulo A + fase B');
subplot(2,3,4), imshow(mat2gray(C2)), title('m�dulo B + fase A');
subplot(2,3,5), imshow(mat2gray(abs(ifft2(magA)))), title('ifft(m�dulo A, fase=0)');
subplot(2,3,6), imshow(mat2gray(abs(ifft2(magB)))), title('ifft(m�dulo B, fase=0)');

% Comparar parecido: usar correlaci�n o RMSE con original
err_C1_vs_A = sqrt(mean((A(:)-C1(:)).^2));
err_C1_vs_B = sqrt(mean((B(:)-C1(:)).^2));
err_C2_vs_A = sqrt(mean((A(:)-C2(:)).^2));
err_C2_vs_B = sqrt(mean((B(:)-C2(:)).^2));

fprintf('\nErrores RMSE intercambio:\n C1 (magA+phaseB) RMSE vs A = %.3e, vs B = %.3e\n', err_C1_vs_A, err_C1_vs_B);
fprintf(' C2 (magB+phaseA) RMSE vs A = %.3e, vs B = %.3e\n', err_C2_vs_A, err_C2_vs_B);

% Observaci�n general:
% - La reconstrucci�n que conserva la fase de una imagen tiende a parecerse mucho
%   m�s a la imagen que proporcion� la fase. La fase contiene la localizaci�n espacial
%   y bordes. El m�dulo aporta informaci�n de energ�as/frecuencias, textura,
%   pero no reconstruye la estructura espacial por s� solo.

%% ===========================
% FIN - Subfunciones (definidas localmente para facilidad)
