function [Pxx] = getPowerAvgDb(equation, fftLength, window, binOverlap, binNumber, binSize)
	kResults = zeros(binNumber, fftLength);
	kFFT = kResults;

	for i = 1:binNumber
		nShift = binSize * (1 - binOverlap);
		kResults(i, 1:binSize) = equation((nShift * (i - 1) + 1):((nShift * (i - 1)) + binSize)) .* window';
		kFFT(i, :) = (1 / sum(window' .^ 2)) * abs(fft(kResults(i, :), fftLength)) .^ 2;
	end
	
	X = sum(kFFT(:,:)) / binNumber;
	XMag = abs(X);
	Pxx = 10*log10(XMag);
end

