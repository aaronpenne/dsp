function [Pxx] = getPowerCoefDb(coefficients, fftLength, window)
	A = fft(coefficients, fftLength);
	X = 1 ./ A;
	XMag = abs(X) .^ 2;
	Pxx = 10 * log10(XMag);
end

