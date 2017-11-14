%% Generate signals
% Construct each of the 6 signal waveforms in the time domain.

clear all; close all; clc;

A = sqrt(0.5);
n = 0:15;
N = length(n);
sigma2 = 1;

% Sinusoid signals
fc = 1 / 16;
s(1,:) = A * sin(2 * pi * fc .* n);
fc = 1 / 4;
s(2,:) = A * sin(2 * pi * fc .* n);
fc = 3 / 8;
s(3,:) = A * sin(2 * pi * fc .* n);

% FM chirp signals
fc = 1 / 16; f_prime = 3 / (8 * 16);
s(4,:) = A * sin(2 * pi * (fc + (f_prime / 2) .* n) .* n);
fc = 1 / 8; f_prime = 1 / (4 * 16);
s(5,:) = A * sin(2 * pi * (fc + (f_prime / 2) .* n) .* n);

%% Optimum waveform
% Generate covariance matrix first
C = eye(16);
for i = 1:15
	C(i,i + 1) = 0.9 / 1.81;
	C(i + 1,i) = 0.9 / 1.81;
end
% Get eigenvector with minimum eigenvalue
[V,D] = eig(C);
s1col = s(1,:)';

eps = s1col'*s1col;
Aopt = sqrt(eps);
s(6,:) = Aopt * V(:,1);

s_col = s';


%% Generate noise
% Construct the colored noise.

wn = randn(1,16);
hwn = 1;
hn = sqrt(1/1.81)*[1,0.9];
noise1 = filter(1,hwn,wn);
noise2 = filter(1,hn,wn);

%% Compute FFT
% Positive frequencies of the magnitude squared of Fourier transforms for
% the signal and noise.

NFFT = 256;
for i = 1:6
    [wS(i,:),S(i,:)] = singleSidedFFT(s(i,:),NFFT);
end
[wH,H] = singleSidedFFT(hn,NFFT);
[wW,W] = singleSidedFFT(hwn,NFFT);

%% Compute detectibility indices and SNR
% Detectors matched for white noise,matched for colored noise,and mismatched.
% d2(i,1): Matched for white noise
% d2(i,2): Matched for colored noise
% d2(i,3): Mismatched

% Detectibility index for all signals
for i = 1:6
	d2(i,1) = s_col(:,i)' * s_col(:,i) / sigma2;
	d2(i,2) = s_col(:,i)' * inv(C) * s_col(:,i);
	d2(i,3) = (s_col(:,i)' * s_col(:,i))^2 / (s_col(:,i)' * C * s_col(:,i));
end

% SNR for all signals
for i = 1:6
	snr_d2(i,1) = s_col(:,i)' * s_col(:,i) / N;
    snr_d2(i,2) = s_col(:,i)' * s_col(:,i) / N;
    snr_d2(i,3) = s_col(:,i)' * s_col(:,i) / N;
end

for i = 1:6
    for j = 1:3
        snr_dB(i,j) = 10*log10(snr_d2(i,j));
    end
end


%% Find performance and plot ROC curves.

eta = -4:0.1:6;

Pf1 = Q(eta);
for i = 1:3
    eta1(i,:) = eta - sqrt(d2(1,i));
    Pd1(i,:) = Q(eta1(i,:));
end

Pf2 = Q(eta);
for i = 1:3
    eta2(i,:) = eta - sqrt(d2(2,i));
    Pd2(i,:) = Q(eta2(i,:));
end

Pf3 = Q(eta);
for i = 1:3
    eta3(i,:) = eta - sqrt(d2(3,i));
    Pd3(i,:) = Q(eta3(i,:));
end

Pf4 = Q(eta);
for i = 1:3
    eta4(i,:) = eta - sqrt(d2(4,i));
    Pd4(i,:) = Q(eta4(i,:));
end

Pf5 = Q(eta);
for i = 1:3
    eta5(i,:) = eta - sqrt(d2(5,i));
    Pd5(i,:) = Q(eta5(i,:));
end

Pf6 = Q(eta);
for i = 1:3
    eta6(i,:) = eta - sqrt(d2(6,i));
    Pd6(i,:) = Q(eta6(i,:));
end

%% Plot all figures

f = 0;
figure; f = f + 1; plot(wW,W); title(['Fig ' num2str(f) ' - Frequency Spectrum of White Noise']);
xlabel('Cycles per Sample'); ylabel(['|H_{WGN}(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on

figure; f = f + 1; plot(wH,H); title(['Fig ' num2str(f) ' - Frequency Spectrum of Correlated Noise']);
xlabel('Cycles per Sample'); ylabel(['|H_{CORR}(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on


% s1
i = 1; % current signal
figure; f = f + 1; plot(0:length(s(i,:))-1,s(i,:)); 
title(['Fig ' num2str(f) ' - Time Series of s_' num2str(i) '(n)']);
xlabel('Samples (n)'); ylabel(['s_' num2str(i) '(n)']); grid on;
figure; subplot(2,2,1); f = f + 1;
plot(wS(i,:),S(i,:)); 
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal']);
xlabel('Cycles per Sample'); ylabel(['|S_' num2str(i) '(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on
subplot(2,2,2); f = f + 1;
plot(wS(i,:),S(i,:)); hold on;
plot(wW,W); hold on; plot(wH,H); hold off;
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal and Noise']);
xlabel('Cycles per Sample'); ylabel('|X(f)|^2 (dB)');
axis([-inf inf -30 20]); grid on
legend('Signal','WGN','Correlated','Location','southwest');
subplot(2,2,3); f = f + 1;
plot(Pf1,Pd1(1,:),'-o'); hold on;
plot(Pf1,Pd1(2,:),'-o'); hold on;
plot(Pf1,Pd1(3,:),':b.');
title(['Fig ' num2str(f) ' - ROC Linear Axis']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');
subplot(2,2,4); f = f + 1;
probpaper_mod(Pf1,Pd1(1,:)); hold on;
probpaper_mod(Pf1,Pd1(2,:)); hold on;
probpaper_mod_dot(Pf1,Pd1(3,:));
title(['Fig ' num2str(f) ' - ROC Probability Paper']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');

% s2
i = i + 1; % current signal
figure; f = f + 1; plot(0:length(s(i,:))-1,s(i,:)); 
title(['Fig ' num2str(f) ' - Time Series of s_' num2str(i) '(n)']);
xlabel('Samples (n)'); ylabel(['s_' num2str(i) '(n)']); grid on;
figure; subplot(2,2,1); f = f + 1;
plot(wS(i,:),S(i,:)); 
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal']);
xlabel('Cycles per Sample'); ylabel(['|S_' num2str(i) '(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on
subplot(2,2,2); f = f + 1;
plot(wS(i,:),S(i,:)); hold on;
plot(wW,W); hold on; plot(wH,H); hold off;
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal and Noise']);
xlabel('Cycles per Sample'); ylabel('|X(f)|^2 (dB)');
axis([-inf inf -30 20]); grid on
legend('Signal','WGN','Correlated','Location','southwest');
subplot(2,2,3); f = f + 1;
plot(Pf2,Pd2(1,:),'-o'); hold on;
plot(Pf2,Pd2(2,:),'-o'); hold on;
plot(Pf2,Pd2(3,:),':b.');
title(['Fig ' num2str(f) ' - ROC Linear Axis']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');
subplot(2,2,4); f = f + 1;
probpaper_mod(Pf2,Pd2(1,:)); hold on;
probpaper_mod(Pf2,Pd2(2,:)); hold on;
probpaper_mod_dot(Pf2,Pd2(3,:));
title(['Fig ' num2str(f) ' - ROC Probability Paper']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');

% s3
i = i + 1; % current signal
figure; f = f + 1; plot(0:length(s(i,:))-1,s(i,:)); 
title(['Fig ' num2str(f) ' - Time Series of s_' num2str(i) '(n)']);
xlabel('Samples (n)'); ylabel(['s_' num2str(i) '(n)']); grid on;
figure; subplot(2,2,1); f = f + 1;
plot(wS(i,:),S(i,:)); 
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal']);
xlabel('Cycles per Sample'); ylabel(['|S_' num2str(i) '(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on
subplot(2,2,2); f = f + 1;
plot(wS(i,:),S(i,:)); hold on;
plot(wW,W); hold on; plot(wH,H); hold off;
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal and Noise']);
xlabel('Cycles per Sample'); ylabel('|X(f)|^2 (dB)');
axis([-inf inf -30 20]); grid on
legend('Signal','WGN','Correlated','Location','southwest');
subplot(2,2,3); f = f + 1;
plot(Pf3,Pd3(1,:),'-o'); hold on;
plot(Pf3,Pd3(2,:),'-o'); hold on;
plot(Pf3,Pd3(3,:),':b.');
title(['Fig ' num2str(f) ' - ROC Linear Axis']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');
subplot(2,2,4); f = f + 1;
probpaper_mod(Pf3,Pd3(1,:)); hold on;
probpaper_mod(Pf3,Pd3(2,:)); hold on;
probpaper_mod_dot(Pf3,Pd3(3,:));
title(['Fig ' num2str(f) ' - ROC Probability Paper']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');

% s4
i = i + 1; % current signal
figure; f = f + 1; plot(0:length(s(i,:))-1,s(i,:)); 
title(['Fig ' num2str(f) ' - Time Series of s_' num2str(i) '(n)']);
xlabel('Samples (n)'); ylabel(['s_' num2str(i) '(n)']); grid on;
figure; subplot(2,2,1); f = f + 1;
plot(wS(i,:),S(i,:)); 
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal']);
xlabel('Cycles per Sample'); ylabel(['|S_' num2str(i) '(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on
subplot(2,2,2); f = f + 1;
plot(wS(i,:),S(i,:)); hold on;
plot(wW,W); hold on; plot(wH,H); hold off;
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal and Noise']);
xlabel('Cycles per Sample'); ylabel('|X(f)|^2 (dB)');
axis([-inf inf -30 20]); grid on
legend('Signal','WGN','Correlated','Location','southwest');
subplot(2,2,3); f = f + 1;
plot(Pf4,Pd4(1,:),'-o'); hold on;
plot(Pf4,Pd4(2,:),'-o'); hold on;
plot(Pf4,Pd4(3,:),':b.');
title(['Fig ' num2str(f) ' - ROC Linear Axis']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');
subplot(2,2,4); f = f + 1;
probpaper_mod(Pf4,Pd4(1,:)); hold on;
probpaper_mod(Pf4,Pd4(2,:)); hold on;
probpaper_mod_dot(Pf4,Pd4(3,:));
title(['Fig ' num2str(f) ' - ROC Probability Paper']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');

% s5
i = i + 1; % current signal
figure; f = f + 1; plot(0:length(s(i,:))-1,s(i,:)); 
title(['Fig ' num2str(f) ' - Time Series of s_' num2str(i) '(n)']);
xlabel('Samples (n)'); ylabel(['s_' num2str(i) '(n)']); grid on;
figure; subplot(2,2,1); f = f + 1;
plot(wS(i,:),S(i,:)); 
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal']);
xlabel('Cycles per Sample'); ylabel(['|S_' num2str(i) '(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on
subplot(2,2,2); f = f + 1;
plot(wS(i,:),S(i,:)); hold on;
plot(wW,W); hold on; plot(wH,H); hold off;
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal and Noise']);
xlabel('Cycles per Sample'); ylabel('|X(f)|^2 (dB)');
axis([-inf inf -30 20]); grid on
legend('Signal','WGN','Correlated','Location','southwest');
subplot(2,2,3); f = f + 1;
plot(Pf5,Pd5(1,:),'-o'); hold on;
plot(Pf5,Pd5(2,:),'-o'); hold on;
plot(Pf5,Pd5(3,:),':b.');
title(['Fig ' num2str(f) ' - ROC Linear Axis']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');
subplot(2,2,4); f = f + 1;
probpaper_mod(Pf5,Pd5(1,:)); hold on;
probpaper_mod(Pf5,Pd5(2,:)); hold on;
probpaper_mod_dot(Pf5,Pd5(3,:));
title(['Fig ' num2str(f) ' - ROC Probability Paper']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');

% s6
i = i + 1; % current signal
figure; f = f + 1; plot(0:length(s(i,:))-1,s(i,:)); 
title(['Fig ' num2str(f) ' - Time Series of s_' num2str(i) '(n)']);
xlabel('Samples (n)'); ylabel(['s_' num2str(i) '(n)']); grid on;
figure; subplot(2,2,1); f = f + 1;
plot(wS(i,:),S(i,:)); 
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal']);
xlabel('Cycles per Sample'); ylabel(['|S_' num2str(i) '(f)|^2 (dB)']);
axis([-inf inf -30 20]); grid on
subplot(2,2,2); f = f + 1;
plot(wS(i,:),S(i,:)); hold on;
plot(wW,W); hold on; plot(wH,H); hold off;
title(['Fig ' num2str(f) ' - Frequency Spectrum of Signal and Noise']);
xlabel('Cycles per Sample'); ylabel('|X(f)|^2 (dB)');
axis([-inf inf -30 20]); grid on
legend('Signal','WGN','Correlated','Location','southwest');
subplot(2,2,3); f = f + 1;
plot(Pf6,Pd6(1,:),'-o'); hold on;
plot(Pf6,Pd6(2,:),'-o'); hold on;
plot(Pf6,Pd6(3,:),':b.');
title(['Fig ' num2str(f) ' - ROC Linear Axis']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');
subplot(2,2,4); f = f + 1;
probpaper_mod(Pf6,Pd6(1,:)); hold on;
probpaper_mod(Pf6,Pd6(2,:)); hold on;
probpaper_mod_dot(Pf6,Pd6(3,:));
title(['Fig ' num2str(f) ' - ROC Probability Paper']);
xlabel('PF'); ylabel('PD'); grid on;
legend('WGN','Correlated','Mismatched','Location','southeast');