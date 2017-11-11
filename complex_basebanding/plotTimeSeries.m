function plotTimeSeries(range, equation, xMinimum, xDivision, xMaximum, yMinimum, yDivision, yMaximum)

	figure;
	plot(range, equation);
	xlabel('Samples (n)'); 
	ylabel('Amplitude');
	xMin = xMinimum; xDiv = xDivision; xMax = xMaximum;
	yMin = yMinimum; yDiv = yDivision; yMax = yMaximum;
	axis([xMin xMax yMin yMax]);
	ax = gca; 
	ax.XTick = xMin:xDiv:xMax; 
	ax.YTick = yMin:yDiv:yMax; 
	grid on; hline(0,'k'); vline(0,'k');

end