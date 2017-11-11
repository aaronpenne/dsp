function [X, F] = plotPowerHz(fftLength, equation, fs, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)
	
	X = fft(equation, fftLength) / fftLength;
	F = fs*(-fftLength/2:fftLength/2-1) / fftLength;
	
	XMag = abs(X) .^ 2;
	XdB = 10*log10(XMag);
	
	plot(F, fftshift(XdB));
	xlabel('Frequency (Hz)'); 
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