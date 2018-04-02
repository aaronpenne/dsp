function [Pxx] = getPowerMvDb(equation, fftLength, pValue, frequency)
	binWidth = 1 / fftLength;
	binValue = ceil(frequency / binWidth);
	E = ones(1, pValue + 1);
	EConj = E;

	for h = 1:pValue
		E(1, h + 1) = exp(1j * 2 * pi * h * binValue / fftLength);
		EConj(1, h + 1) = conj(E(1, h + 1));
	end
	
	r = autocorr(equation, pValue);
	R = toeplitz(r);

	mv = (1 * pValue) ./ (E * inv(R) * EConj');
	
	XMag = abs(mv);
	Pxx = 10*log10(XMag);
end