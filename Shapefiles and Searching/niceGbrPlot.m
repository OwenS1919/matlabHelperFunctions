function niceGbrPlot(gbrShapeLL, qldOutline, noLabelInd, boundary)
% niceGbrPlot() will create a nice looking plot of the gbr :3

% inputs:

% gbrShapeLL - holds the reef outlines in a structure with fields X and Y
    % storing the X and Y coordinates
% qldOutline - holds the outline of qld in a structure with fields X and Y
% noLabelInd - optional - if taking value "noLabel" then no label for qld
    % will be drawn - default is "yes"
% boundary - optional - provides a limit for plotting of the form [xMin,
    % xMax, yMin, yMax], so that only shapes with centroids in this range
    % are plotted - default is [] i.e. no boundary applied

% set default for noLabelInd
if nargin < 3 || isempty(noLabelInd)
    noLabelInd = "yes";
end

% plot down the reefs
if nargin == 4
    plotShapes(gbrShapeLL, 'colour', getColour('lb'), 'fill', ...
        'yes', 'alpha', 0.5, 'boundary', boundary)
else
    plotShapes(gbrShapeLL, 'colour', getColour('lb'), 'fill', ...
        'yes', 'alpha', 0.5)
end

% plot down the qld outline and label it
plotShapes(qldOutline, 'colour', getColour('br'), 'fill', 'yes', ...
    'alpha', 0.2)
plotShapes(qldOutline, 'colour', 'k')
if noLabelInd ~= "noLabel"
    text(144, -20, "QLD")
end

end