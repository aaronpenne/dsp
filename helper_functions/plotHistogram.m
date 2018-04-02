function plotHistogram(equation, edges, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)

	histogram(equation, edges, 'FaceColor', [0.8 0.8 0.8]); hold on;

	xlabel('Power/Cycles/Sample (dB)'); 
	ylabel('Count'); 
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


