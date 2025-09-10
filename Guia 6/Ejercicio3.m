close all; clear; clc;

%% ===============================
% Lectura de imagen de prueba
% (usar 'cameraman.tif' o 'lena.png' si la tenés)
I = im2double(imread('cameraman.tif'));
[M,N] = size(I);

%% ===============================
% a) Implementación de filtros ideales: LP, HP, Notch
D0 = 40; % radio de corte
H_lp = filtro_ideal(M,N,'lowpass',D0);
H_hp = filtro_ideal(M,N,'highpass',D0);
H_notch = filtro_notch(M,N,80,0,15); % notch en (u=80,v=0), radio 15

% FFT de la imagen
F = fft2(I);
Fshift = fftshift(F);

% Aplicación de los filtros
I_lp = real(ifft2(ifftshift(Fshift .* H_lp)));
I_hp = real(ifft2(ifftshift(Fshift .* H_hp)));
I_notch = real(ifft2(ifftshift(Fshift .* H_notch)));

figure('Name','Filtros ideales');
subplot(2,3,1), imshow(I,[]), title('Original');
subplot(2,3,2), imshow(log(1+abs(Fshift)),[]), title('Espectro original');
subplot(2,3,3), imshow(I_lp,[]), title('Pasa-bajos ideal');
subplot(2,3,4), imshow(I_hp,[]), title('Pasa-altos ideal');
subplot(2,3,5), imshow(I_notch,[]), title('Notch ideal');

% Comentario:
% - El pasa-bajos suaviza (borra bordes finos, detalles).
% - El pasa-altos resalta bordes, ruido.
% - El notch elimina una frecuencia puntual (se usa para senoidales de ruido).

%% ===============================
% b) Comparar espectro tras filtrar
F_lp = fftshift(fft2(I_lp));
figure('Name','Comparación espectro filtrado');
subplot(1,2,1), imshow(log(1+abs(Fshift.*H_lp)),[]), title('Espectro filtrado (en freq)');
subplot(1,2,2), imshow(log(1+abs(F_lp)),[]), title('FFT(imagen filtrada)');

% Observación:
% Los dos espectros son equivalentes ? aplicar el filtro en freq = 
% calcular FFT de imagen filtrada.

%% ===============================
% c) Contaminar con una senoidal conocida
[X,Y] = meshgrid(1:N,1:M);
ruido = 0.2*sin(2*pi*0.1*X); % senoidal en x
I_ruido = I + ruido;

F_r = fftshift(fft2(I_ruido));

figure('Name','Imagen contaminada con senoidal');
subplot(1,3,1), imshow(I,[]), title('Original');
subplot(1,3,2), imshow(I_ruido,[]), title('Con ruido senoidal');
subplot(1,3,3), imshow(log(1+abs(F_r)),[]), title('Espectro con picos');

% Aplicar notch en posición de los picos
H_notch2 = filtro_notch(M,N,30,0,10);
I_filt = real(ifft2(ifftshift(F_r .* H_notch2)));

figure('Name','Eliminación de senoidal');
subplot(1,2,1), imshow(I_ruido,[]), title('Con ruido');
subplot(1,2,2), imshow(I_filt,[]), title('Filtrada (notch)');

% i) Si se agregan 2 senoidales distintas, aparecerán 4 picos (±f1, ±f2).
% Habrá que usar 2 filtros notch para eliminarlas.

%% ===============================
% d) Filtros Butterworth y Chebyshev
D0 = 40; n = 2; % frecuencia de corte y orden
H_bw = filtro_butterworth(M,N,'lowpass',D0,n);
H_ch = filtro_chebyshev(M,N,'lowpass',D0,n,0.5);

I_bw = real(ifft2(ifftshift(Fshift .* H_bw)));
I_ch = real(ifft2(ifftshift(Fshift .* H_ch)));

figure('Name','Butterworth y Chebyshev');
subplot(2,2,1), imshow(I,[]), title('Original');
subplot(2,2,2), imshow(I_bw,[]), title('Butterworth LP');
subplot(2,2,3), imshow(I_ch,[]), title('Chebyshev LP');





