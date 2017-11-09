clear all; close all; clc;

fig = 0;
h = 0;
nfft = 256;

windowHamming = hamming(nfft);
windowHamming32 = hamming(32);

F = ((-nfft / 2):(nfft / 2 - 1)) / nfft;
frequencies = [0.0625, 0.0938, 0.125];
frequenciesAll = -0.5:(1 / (nfft - 1)):0.5;

p = [14, 28];

times = 10;
realizations = 100;

%--------------------------------------------------------------------------
% Get transfer function from coefficients
%--------------------------------------------------------------------------
n = 256;
nRange = 1:n;
a = zeros(1, nfft);
a(1:10) = poly([0.9896 * exp(j * 1 * pi / 8) ...
          0.9843 * exp(j * 2 * pi / 8) ...
          0.9780 * exp(j * 3 * pi / 8) ...
          0.9686 * exp(j * 4 * pi / 8) ...
          0.9896 * exp(-j * 1 * pi / 8) ...
          0.9843 * exp(-j * 2 * pi / 8) ...
          0.9780 * exp(-j * 3 * pi / 8) ...
          0.9686 * exp(-j * 4 * pi / 8) ...
          0 ...
         ]);

x = filter(1, a, randn(1, 1280));
xSegment = zeros(times, nfft);
for i = 1:times
    xSegment(i, :) = x((64 * (i - 1)) + 1:(64 * (i - 1)) + nfft);
end
figure, fig = fig + 1; h = h + 1;
Pxx = getPowerCoefDb(a, nfft, windowHamming);
PxxAvg(h, :) = Pxx;
stats(h, 1) = mean(PxxAvg(h, :), 2); stats(h, 2) = std(PxxAvg(h, :), 0, 2);
plotPowerDb(F, Pxx, frequencies, 0, 0.0625, 0.5, -30, 10, 50);
title(['Fig ' num2str(fig) ' - Known power spectrum from coefficients']);
print(['fig' num2str(fig)],'-djpeg', '-r0');


%--------------------------------------------------------------------------
% Averages and stats of 1000 realizations (100 random signals * 10 chunks)
%--------------------------------------------------------------------------
Pxx = zeros(times, nfft);

% B.1 Unaveraged
for index = 1:realizations
    x = filter(1, a, randn(1, 1280));
    for i = 1:times
    	Pxx(index + i - 1, :) = getPowerDb(x((64 * (i - 1)) + 1:(64 * (i - 1)) + nfft), nfft, windowHamming);
    end
end
h = h + 1;
PxxAvg(h, :) = sum(Pxx, 1) / (realizations + i - 1);
stats(h, 1) = mean(PxxAvg(h, :), 2); stats(h, 2) = std(PxxAvg(h, :), 0, 2);

% B.2 Averaged
for index = 1:realizations
    x = filter(1, a, randn(1, 1280));
    for i = 1:times
    	Pxx(index + i - 1, :) = getPowerAvgDb(x((64 * (i - 1)) + 1:(64 * (i - 1)) + nfft), nfft, windowHamming32, 0.5, 15, 32);
    end
end
h = h + 1;
PxxAvg(h, :) = sum(Pxx, 1) / (realizations + i - 1);
stats(h, 1) = mean(PxxAvg(h, :), 2); stats(h, 2) = std(PxxAvg(h, :), 0, 2);

% C.A LPC p=14
order = p(1);
for index = 1:realizations
    x = filter(1, a, randn(1, 1280));
    for i = 1:times
    	Pxx(index + i - 1, :) = getPowerLpcDb(x((64 * (i - 1)) + 1:(64 * (i - 1)) + nfft), nfft, windowHamming, order);
    end
end
h = h + 1;
PxxAvg(h, :) = sum(Pxx, 1) / (realizations + i - 1);
stats(h, 1) = mean(PxxAvg(h, :), 2); stats(h, 2) = std(PxxAvg(h, :), 0, 2);

% C.B LPC p=28
order = p(2);
for index = 1:realizations
    x = filter(1, a, randn(1, 1280));
    for i = 1:times
    	Pxx(index + i - 1, :) = getPowerLpcDb(x((64 * (i - 1)) + 1:(64 * (i - 1)) + nfft), nfft, windowHamming, order);
    end
end
h = h + 1;
PxxAvg(h, :) = sum(Pxx, 1) / (realizations + i - 1);
stats(h, 1) = mean(PxxAvg(h, :), 2); stats(h, 2) = std(PxxAvg(h, :), 0, 2);

% D.A MV p=14
order = p(1);
for index = 1:realizations
    x = filter(1, a, randn(1, 1280));
    for i = 1:times
    	indexH = 0;
        for k = frequenciesAll + 1
            indexH = indexH + 1;
            Pxx(index + i - 1, indexH) = getPowerMvDb(x((64 * (i - 1)) + 1:(64 * (i - 1)) + nfft), nfft, order, k - 1);
        end
    end
end
h = h + 1;
PxxAvg(h, :) = sum(Pxx, 1) / (realizations + i - 1);
stats(h, 1) = mean(PxxAvg(h, :), 2); stats(h, 2) = std(PxxAvg(h, :), 0, 2);

% D.B MV p=28
order = p(2);
for index = 1:realizations
    x = filter(1, a, randn(1, 1280));
    for i = 1:times
    	indexH = 0;
        for k = frequenciesAll + 1
            indexH = indexH + 1;
            Pxx(index + i - 1, indexH) = getPowerMvDb(x((64 * (i - 1)) + 1:(64 * (i - 1)) + nfft), nfft, order, k - 1);
        end
    end
end
h = h + 1;
PxxAvg(h, :) = sum(Pxx, 1) / (realizations + i - 1);
stats(h, 1) = mean(PxxAvg(h, :), 2); stats(h, 2) = std(PxxAvg(h, :), 0, 2);

%--------------------------------------------------------------------------
% Plot 10x of each
%--------------------------------------------------------------------------
times = 10;
h = 1;

% B.1 Unaveraged
figure, fig = fig + 1;
for i = 1:times
	Pxx(i, :) = getPowerDb(xSegment(i,:), nfft, windowHamming);
	plotPowerDb(F, Pxx(i, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
title(['Fig ' num2str(fig) ' - Spectral estimates w/conventional long FFT']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure, fig = fig + 1; h = h + 1;
plotPowerDb(F, PxxAvg(h, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50);
title(['Fig ' num2str(fig) ' - Avg of spectral estimates w/conventional long FFT']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

% B.2 Averaged
figure, fig = fig + 1;
for i = 1:times
	Pxx(i, :) = getPowerAvgDb(xSegment(i,:), nfft, windowHamming32, 0.5, 15, 32);
	plotPowerDb(F, Pxx(i, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
title(['Fig ' num2str(fig) ' - Spectral estimate w/averaged short FFTs']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure, fig = fig + 1; h = h + 1;
plotPowerDb(F, PxxAvg(h, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50);
title(['Fig ' num2str(fig) ' - Avg of spectral estimates w/averaged short FFTs']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

% C.A LPC p=14
figure, fig = fig + 1;
order = p(1);
for i = 1:times
	Pxx(i, :) = getPowerLpcDb(xSegment(i,:), nfft, windowHamming, order);
	plotPowerDb(F, Pxx(i, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
title(['Fig ' num2str(fig) ' - Spectral estimate w/LPC with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure, fig = fig + 1; h = h + 1;
plotPowerDb(F, PxxAvg(h, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50);
title(['Fig ' num2str(fig) ' - Avg of spectral estimate w/LPC with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

% C.B LPC p=28
figure, fig = fig + 1;
order = p(2);
for i = 1:times
	Pxx(i, :) = getPowerLpcDb(xSegment(i,:), nfft, windowHamming, order);
	plotPowerDb(F, Pxx(i, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
title(['Fig ' num2str(fig) ' - Spectral estimate w/LPC with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure, fig = fig + 1; h = h + 1;
plotPowerDb(F, PxxAvg(h, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50);
title(['Fig ' num2str(fig) ' - Avg of spectral estimate w/LPC with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

% D.A MV p=14
figure, fig = fig + 1;
order = p(1);
for i = 1:times
	index = 0;
	for k = frequenciesAll + 1
		index = index + 1;
		Pxx(i, index) = getPowerMvDb(xSegment(i,:), nfft, order, k - 1);
    end
	plotPowerDbNoShift(F, Pxx(i, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
title(['Fig ' num2str(fig) ' - Spectral estimate w/MV with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure, fig = fig + 1; h = h + 1;
plotPowerDbNoShift(F, PxxAvg(h, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50);
title(['Fig ' num2str(fig) ' - Avg of spectral estimate w/MV with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

% D.B MV p=28
figure, fig = fig + 1;
order = p(2);
for i = 1:times
	index = 0;
	for k = frequenciesAll + 1
		index = index + 1;
		Pxx(i, index) = getPowerMvDb(xSegment(i,:), nfft, order, k - 1);
    end
	plotPowerDbNoShift(F, Pxx(i, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
title(['Fig ' num2str(fig) ' - Spectral estimate w/MV with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure, fig = fig + 1; h = h + 1;
plotPowerDbNoShift(F, PxxAvg(h, :), frequencies, 0, 0.0625, 0.5, -30, 10, 50);
title(['Fig ' num2str(fig) ' - Avg of spectral estimate w/MV with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

%--------------------------------------------------------------------------
% Plot 1000x averages on the same plot
%--------------------------------------------------------------------------
figure, fig = fig + 1;
for i = 1:5
    plotPowerDbNoAxis(F, PxxAvg(i, :), 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
for i = 6:7
    plotPowerDbNoShiftNoAxis(F, PxxAvg(i, :), 0, 0.0625, 0.5, -30, 10, 50); hold on;
end
legend('Known', 'Conventional', 'Averaged', 'LPC p=14', 'LPC p=28', 'MV p=14', 'MV p=28');
plotAxis(); plotLines(frequencies);
title(['Fig ' num2str(fig) ' - Spectral estimate methods (averages of 1000 runs)']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

%--------------------------------------------------------------------------
% Plot histograms
%--------------------------------------------------------------------------
edges = 0:5:50;
h = 0;

figure; fig = fig + 1; h = h + 1;
plotHistogram(PxxAvg(h,:), edges, 0, 5, 50, 0, 5, 50)
title(['Fig ' num2str(fig) ' - Histogram w/known spectrum']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure; fig = fig + 1; h = h + 1;
plotHistogram(PxxAvg(h,:), edges, 0, 5, 50, 0, 5, 50)
title(['Fig ' num2str(fig) ' - Histogram w/conventional long FFT']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure; fig = fig + 1; h = h + 1;
plotHistogram(PxxAvg(h,:), edges, 0, 5, 50, 0, 5, 50)
title(['Fig ' num2str(fig) ' - Histogram w/averaged short FFTs']);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure; fig = fig + 1; h = h + 1;
order = p(1);
plotHistogram(PxxAvg(h,:), edges, 0, 5, 50, 0, 5, 50)
title(['Fig ' num2str(fig) ' - Histogram w/LPC with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure; fig = fig + 1; h = h + 1;
order = p(2);
plotHistogram(PxxAvg(h,:), edges, 0, 5, 50, 0, 5, 50)
title(['Fig ' num2str(fig) ' - Histogram w/LPC with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure; fig = fig + 1; h = h + 1;
order = p(1);
plotHistogram(PxxAvg(h,:), edges, 0, 5, 50, 0, 5, 50)
title(['Fig ' num2str(fig) ' - Histogram w/MV with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');

figure; fig = fig + 1; h = h + 1;
order = p(2);
plotHistogram(PxxAvg(h,:), edges, 0, 5, 50, 0, 5, 50)
title(['Fig ' num2str(fig) ' - Histogram w/MV with p=' num2str(order)]);
print(['fig' num2str(fig)],'-djpeg', '-r0');
