function [ output_args ] = plotLines( input_args )
	for index = 1:length(lines)
		xVal = lines(index);
		plot([xVal xVal], [yMin, yMax], '--k'); hold on;
	end
end

