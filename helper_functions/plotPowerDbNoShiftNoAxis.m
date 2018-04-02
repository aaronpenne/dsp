function plotPowerDbNoShiftNoAxis(frequency, powerDb, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)
	plot(frequency, powerDb); hold on;
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
end


