clear all; close all; clc;

fig = 0;

n = 4096;
nRange = 0:(4096 - 1);
nfft = 256;
nfftRange = 0:(nfft - 1);

fs = 1000;
f0 = 250 / fs;
f1 = 160 / fs
f2 = 237 / fs
f3 = 240 / fs

% I.A - Generate data set
x1 = 100 * cos(2 * pi * nRange * f1);
x2 =  10 * cos(2 * pi * nRange * f2);
x3 =   1 * cos(2 * pi * nRange * f3);
x = x1 + x2 + x3;

% I.B - Plot x(n)
fig = fig + 1;
plotTimeSeries(nRange, x, 0, 32, nfft, -120, 20, 120);
title(['Fig ' num2str(fig) ' - x(n) Data set of three sinusoids']);

% I.B - Generate window
beta = 7.85;
windowKaiser = kaiser(nfft, beta);

% I.B - Take FFT of x
fig = fig + 1;
plotFftMag(nfft, (x(1:nfft) .* windowKaiser'), -0.5, 0.125, 0.5, -40, 10, 80);
title(['Fig ' num2str(fig) ' - |X(k)|']);

% II.A - Filter design
firLowPass= designfilt('lowpassfir', ...
	'FilterOrder', 64, ...
	'PassbandFrequency', 40, ...
	'StopbandFrequency', 85, ...
	'DesignMethod', 'equiripple', ...
	'SampleRate', fs, ...
	'PassbandWeight', 50, ...
	'StopbandWeight', 1);

% II.B - Filter amplitude
[hLowPass, nLowPass] = impz(firLowPass);
fig = fig + 1;
plotDiscreteSeries(nLowPass, hLowPass, 0, 16, 64, -0.04, 0.02, 0.16);
title(['Fig ' num2str(fig) ' - LPF h(n)']);

% II.B - Filter magnitude
fig = fig + 1;
plotFftMag(1024, hLowPass, -0.5, 0.125, 0.5, -60, 10, 10);
title(['Fig ' num2str(fig) ' - LPF |H(k)|']);

% II.B - Filter magnitude zoomed
fig = fig + 1;
plotFftMag(1024, hLowPass, -0, 0.01, 40/fs, -0.002, 0.0005, 0.002);
title(['Fig ' num2str(fig) ' - LPF |H(k)| Zoomed on Passband Ripples']);
  
% III.A - Top Branch step 1
xTop1 = x .* cos(2 * pi * f0 * nRange);
fig = fig + 1;
plotFftMag(nfft, (xTop1(1:nfft) .* windowKaiser'), -0.5, 0.125, 0.5, -40, 10, 80);
title(['Fig ' num2str(fig) ' - |X.IA(k)|']);

% III.A - Bottom Branch step 1
xBot1 = x .* -1 .* sin(2 * pi * f0 * nRange);
fig = fig + 1;
plotFftMag(nfft, (xBot1(1:nfft) .* windowKaiser'), -0.5, 0.125, 0.5, -40, 10, 80);
title(['Fig ' num2str(fig) ' - |X.IB(k)|']);

% III.B - Top Branch step 2
xTop2 = filter(firLowPass, xTop1);
fig = fig + 1;
plotFftMag(nfft, (xTop2(1:nfft) .* windowKaiser'), -0.5, 0.125, 0.5, -40, 10, 80);
title(['Fig ' num2str(fig) ' - |X.IIA(k)|']);

% III.B - Bottom Branch step 2
xBot2 = filter(firLowPass, xBot1);
fig = fig + 1;
plotFftMag(nfft, (xBot2(1:nfft) .* windowKaiser'), -0.5, 0.125, 0.5, -40, 10, 80);
title(['Fig ' num2str(fig) ' - |X.IIB(k)|']);

% IV.A - Step 3
xTop3 = downsample(xTop2, 8);
xBot3 = downsample(xBot2, 8);
xPrime = xTop3 + (1j * xBot3);
fig = fig + 1;
plotFftMag(nfft, (xPrime(nfft+1:length(xPrime)) .* windowKaiser'), -0.5, 0.125, 0.5, -40, 10, 80);
title(['Fig ' num2str(fig) ' - |X''(k)|']);

%% Second Iteration

% II.A - Filter design
firLowPass= designfilt('lowpassfir', ...
	'FilterOrder', 64, ...
	'PassbandFrequency', 40, ...
	'StopbandFrequency', 85, ...
	'DesignMethod', 'equiripple', ...
	'SampleRate', fs, ...
	'PassbandWeight', 1, ...
	'StopbandWeight', 100);

% II.B - Filter amplitude
[hLowPass, nLowPass] = impz(firLowPass);
fig = fig + 1;
plotDiscreteSeries(nLowPass, hLowPass, 0, 16, 64, -0.04, 0.02, 0.14);
title(['Fig ' num2str(fig) ' - LPF h(n)']);

% II.B - Filter magnitude
fig = fig + 1;
plotFftMag(1024, hLowPass, -0.5, 0.125, 0.5, -90, 10, 10);
title(['Fig ' num2str(fig) ' - LPF |H(k)|']);

% II.B - Filter magnitude zoomed
fig = fig + 1;
plotFftMag(1024, hLowPass, -0, 0.01, 40/fs, -0.25, 0.125, 0.25);
title(['Fig ' num2str(fig) ' - LPF |H(k)| Zoomed on Passband Ripples']);
  
% III.A - Top Branch step 1
xTop1 = x .* cos(2 * pi * f0 * nRange);

% III.A - Bottom Branch step 1
xBot1 = x .* -1 .* sin(2 * pi * f0 * nRange);

% III.B - Top Branch step 2
xTop2 = filter(firLowPass, xTop1);

% III.B - Bottom Branch step 2
xBot2 = filter(firLowPass, xBot1);

% IV.A - Step 3
xTop3 = downsample(xTop2, 8);
xBot3 = downsample(xBot2, 8);
xPrime = xTop3 + (1j * xBot3);
fig = fig + 1;
plotFftMag(nfft, (xPrime(nfft+1:length(xPrime)) .* windowKaiser'), -0.5, 0.125, 0.5, -40, 10, 80);
title(['Fig ' num2str(fig) ' - |X''(k)|']);