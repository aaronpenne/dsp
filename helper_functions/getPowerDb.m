function [Pxx] = getPowerDb(equation, fftLength, window)
	x = equation .* window';
	X = fft(x, fftLength);
	XMag = (abs(X) .^ 2) / fftLength;
	Pxx = 10*log10(XMag);
end

