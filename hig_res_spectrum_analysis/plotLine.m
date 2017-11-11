function plotLine(xValArray, lineType)
	hold on;
	for index = 1:3
		xVal = xValArray(index);
		plot([xVal xVal], ylim, lineType); hold on;
	end
	hold off;
end