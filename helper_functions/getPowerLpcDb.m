function [Pxx] = getPowerLpcDb(equation, fftLength, window, pValue)
	[a g] = lpc(equation .* window', pValue);
	A = fft(a, fftLength);
	X = 1 ./ A;
	XMag = abs(X) .^ 2;
	Pxx = 10*log10(XMag);
end

