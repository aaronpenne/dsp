function plotPowerDb(frequency, powerDb, lines, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)
	plot(frequency, fftshift(powerDb), 'k'); hold on;
	xlabel('Cycles/Sample'); 
	ylabel('Power/Cycles/Sample (dB)'); 
	xMin = xMinimum; xDiv = xDivision; xMax = xMaximum;
	yMin = yMinimum; yDiv = yDivision; yMax = yMaximum;
	axis([xMin xMax yMin yMax]);
	grid on; 
	if((isinf(xMinimum) == 0) && (isinf(xMaximum) == 0));
		ax = gca; 
		ax.XTick = xMin:xDiv:xMax;
	end	
	if((isinf(yMinimum) == 0) && (isinf(yMaximum) == 0))
		ax = gca; 
		ax.YTick = yMin:yDiv:yMax;
	end 
	
	for index = 1:length(lines)
		xVal = lines(index);
		plot([xVal xVal], [yMin, yMax], '--k'); hold on;
	end
	plotAxis();
end


