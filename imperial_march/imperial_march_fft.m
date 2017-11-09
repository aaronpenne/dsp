% imperial_march_fft.m

close all;
clc;

[x,fs] = audioread('C:\home\docs\imperial_march\imperial_march_noisy.wav');
T = 1/fs;
Lbit = length(x);
Lsec = Lbit/fs;
t = linspace(0, Lsec, Lbit);
 
X1 = fftshift(fft(x));                  % fft of entire song
X2 = fftshift(fft(x(fs*2:fs*3-1)));     % fft of one second sample at 2 secs
X3 = fftshift(fft(x(fs*16:fs*17-1)));   % fft of one second sample at 16 secs
f1 = -fs/2:fs/Lbit:fs/2-fs/Lbit;
f2 = -fs/2:fs/length(X2):fs/2-fs/length(X2);
f3 = -fs/2:fs/length(X2):fs/2-fs/length(X2);
 
% Song and DFT of song
figure(1);
subplot(2,1,1); plot(x);
title('Corrupted Signal - Time Domain');xlabel('sec');ylabel('x[n]');
grid on;grid minor;axis tight;
subplot(2,1,2);stem(f1,1/Lbit*abs(X1),'filled');
title('Magnitude Spectrum of Entire Song');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
 
% DFT of 2 samples
figure(2);
subplot(2,1,1);stem(f2,1/Lbit*abs(X2),'filled');
title('Magnitude Spectrum of 1 Sec Sample at t=2');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
subplot(2,1,2);stem(f3,1/Lbit*abs(X3),'filled');
title('Magnitude Spectrum of 1 Sec Sample at t=16');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
 
% DFT of sample at t=2 (Zoomed on noise)
figure(3);
stem(f2,1/Lbit*abs(X2),'filled');    % Zoomed manually
title('Magnitude Spectrum of 1 Sec Sample at t=2 (Zoomed on noise)');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
 
% DFT of sample at t=2 (Zoomed on noise)
figure(4);
stem(f3,1/Lbit*abs(X3),'filled');    % Zoomed manually
title('Magnitude Spectrum of 1 Sec Sample at t=16 (Zoomed on noise)');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
