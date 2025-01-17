function plotPoints = formRectangle(rectLims)
% plotRectangle() will simply plot a rectangle based on a vector holding
% the maximum and minimum vertex values

% input:

% rectLims - the limits of the rectangle in the form [xMin, xMax, yMin, 
    % yMax]

% ouptut:

% plotPoints - outputs the points to plot in the form of plotPoints(:, 1) =
    % x, plotPoints(:, 2) = y

% just order the points in the manner they should be used, starting from
% the bottom right
xPoints = [rectLims(1), rectLims(2), rectLims(2), rectLims(1), ...
    rectLims(1)];
yPoints = [rectLims(3), rectLims(3), rectLims(4), rectLims(4), ...
    rectLims(3)];

% return the points to plot
plotPoints = [xPoints', yPoints'];

end