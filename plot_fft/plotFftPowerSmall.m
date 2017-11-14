function [X, F] = plotFftPowerSmall(fftLength, equation, windowCustom, overlap, overlapBins, binSize, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)

	kResults = zeros(overlapBins, fftLength);
	kFFT = kResults;

	for i = 1:overlapBins
		nShift = binSize * (1 - overlap);
		kResults(i, 1:binSize) = equation((nShift * (i - 1) + 1):((nShift * (i - 1)) + binSize)) .* windowCustom';
		kResults(i, binSize:fftLength) = 0;
		kFFT(i, :) = (1 / sum(windowCustom .^ 2)) * abs(fft(kResults(i, :), fftLength)) .^ 2;
	end
	
	X = sum(kFFT(:,:))/overlapBins;
	F = (-fftLength/2:fftLength/2-1)/fftLength;
	
	XMag = abs(X);
	XdB = 10*log10(XMag);
	plot(F, fftshift(XdB));
	xlabel('Cycles/Sample'); 
	ylabel('Power/Cycles/Sample (dB)'); 
	xMin = xMinimum; xDiv = xDivision; xMax = xMaximum;
	yMin = yMinimum; yDiv = yDivision; yMax = yMaximum;
	axis([xMin xMax yMin yMax]);
	grid on; 
	if((isinf(xMinimum) == 0) && (isinf(xMaximum) == 0));
		ax = gca; 
		ax.XTick = xMin:xDiv:xMax;
		line(xlim, [0 0], 'color', 'k'); 
	end	
	if((isinf(yMinimum) == 0) && (isinf(yMaximum) == 0))
		ax = gca; 
		ax.YTick = yMin:yDiv:yMax;
		line([0 0], ylim, 'color', 'k'); 
	end 
end