function plotFftPhase(fftLength, equation, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)

	X = fft(equation, fftLength);
	F = (-fftLength/2:fftLength/2-1)/fftLength;
	
    XPhase = angle(X);
	plot(F, XPhase);
	xlabel('Cycles/Sample'); 
	ylabel('Phase (radians)'); 
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