clear all; close all; clc;

fig = 0;
nfft = 256;
nRangeMin = 1024;
nRangeMax = 1279;
nRange = nRangeMin:nRangeMax;
windowHamming = hamming(nfft);
windowHamming64 = hamming(64);

load('speech.mat');
speechAll = cat(2, speech_i, speech_ng, speech_u);
speechNames = {'/i/', '/u/', '/\eta/'};
speech = zeros(3, nfft);
for i = 1:3
   speech(i, :) = speechAll(nRange, i); 
end

fs = 10000;

for i = 1:3
    %% Part A
    
    % Part A.1
	figure; fig = fig + 1;
	plotTimeSeries(nRange, speech(i, :), nRangeMin, 32, nRangeMax + 1, -600, 100, 600);
    title(['Fig ' num2str(fig) ' - Time Series of phoneme ' speechNames{i}]);
    set(gcf,'PaperPositionMode','auto')
    print(['fig' num2str(fig)],'-djpeg', '-r0');
    
    % Part A.2
    figure; fig = fig + 1;
	plotPowerHz(nfft, speech(i, :) .* windowHamming', fs, 0, fs/10, fs/2, -30, 10, 40)
    title(['Fig ' num2str(fig) ' - Power Spectrum of phoneme ' speechNames{i} ' n=256']);
    set(gcf,'PaperPositionMode','auto')
    print(['fig' num2str(fig)],'-djpeg', '-r0');
    
    speech64 = zeros(1, nfft);
	figure; fig = fig + 1;
    speech64(1:64) = speech(i, 1:64) .* windowHamming64';
	plotPowerHz(nfft, speech64, fs, 0, fs/10, fs/2, -30, 10, 40)
    title(['Fig ' num2str(fig) ' - Power Spectrum of phoneme ' speechNames{i} ' n=64']);
    set(gcf,'PaperPositionMode','auto')
    print(['fig' num2str(fig)],'-djpeg', '-r0');
    
    %% Part B
    
    % Part B.1
    p = [2 4 6 8 10 12 14];
    % n=256
    gPredicted = zeros(length(p), 1);
	for j = 1:length(p)
		[tmp, gPredicted(j)] = lpc(speech(i, :) .* windowHamming', p(j));
	end
	figure; fig = fig + 1;
	plot(p, gPredicted);
	title(['Fig ' num2str(fig) ' - Error vs Filter Order for phoneme ' speechNames{i} ' n=256']);
	xlabel('Filter Order (p)'); 
	ylabel('E_p');
	grid on;
    set(gcf,'PaperPositionMode','auto')
    print(['fig' num2str(fig)],'-djpeg', '-r0');
    
    % n=64
    gPredicted = zeros(length(p), 1);
    speech64 = zeros(1, 64);
    speech64 = speech(i, 1:64);
	for j = 1:length(p)
		[tmp, gPredicted(j)] = lpc(speech64 .* windowHamming64', p(j));
	end
	figure; fig = fig + 1;
	plot(p, gPredicted);
	title(['Fig ' num2str(fig) ' - Error vs Filter Order for phoneme ' speechNames{i} ' n=64']);
	xlabel('Filter Order (p)'); 
	ylabel('E_p');
	grid on;
    set(gcf,'PaperPositionMode','auto')
    print(['fig' num2str(fig)],'-djpeg', '-r0');
    
    % Part B.2
    p = 14;
    
    % n=256
    aPredicted = zeros(1, nfft);
    [aPredicted(1, 1:p+1), tmp] = lpc(speech(i, :) .* windowHamming', p);
    figure; fig = fig + 1;
    plotPowerHzA(nfft, aPredicted, fs, 0, fs/10, fs/2, -30, 10, 40);
    title(['Fig ' num2str(fig) ' - Estimated Power Spectrum at p=14 for ' speechNames{i} ' n=256']);
    set(gcf,'PaperPositionMode','auto')
    print(['fig' num2str(fig)],'-djpeg', '-r0');

    % n=64
    aPredicted = zeros(1, nfft);
    speech64 = zeros(1, 64);
    speech64 = speech(i, 1:64);
    [aPredicted(1, 1:p+1), tmp] = lpc(speech64 .* windowHamming64', p);
    figure; fig = fig + 1;
    plotPowerHzA(nfft, aPredicted, fs, 0, fs/10, fs/2, -30, 10, 40);
    title(['Fig ' num2str(fig) ' - Estimated Power Spectrum at p=14 for ' speechNames{i} ' n=64']);
    set(gcf,'PaperPositionMode','auto')
    print(['fig' num2str(fig)],'-djpeg', '-r0');
end
