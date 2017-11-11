function plotFftMag(fftLength, equation, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)

	X = fft(equation, fftLength);
	F = (-fftLength/2:fftLength/2-1)/fftLength;
    XMag = fftshift(20*log10(abs(X)));
	figure;
	plot(F, XMag);
	xlabel('Cycles/Sample'); 
	ylabel('Magnitude (dB)'); 
	xMin = xMinimum; xDiv = xDivision; xMax = xMaximum;
	yMin = yMinimum; yDiv = yDivision; yMax = yMaximum;
	axis([xMin xMax yMin yMax]);
	ax = gca; 
	ax.XTick = xMin:xDiv:xMax; 
	ax.YTick = yMin:yDiv:yMax; 
	grid on; hline(0,'k'); vline(0,'k');
end