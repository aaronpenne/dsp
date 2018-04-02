function plotLines(lines)
	for index = 1:length(lines)
		xVal = lines(index);
		plot([xVal xVal], ylim, '--k'); hold on;
	end
end