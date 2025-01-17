function plotCentroids(GBRShape, axisVec, magnitudes, clims)
% plotCentroids will plot the centroids of the reefs stored in GBRShape

% input:
% GBRShape - stores the outlines and centroids of reefs on the GBR,
%     centroids stored in the field "Centroid"
% axisVec - optional - specify a vector which will form the principle axis
%     for a coordinate translation for plotting, mainly just for me to help
%     test the reef orderings code
% magnitudes - optional - if specified, centroid plotting point colours
%     will reflect the magnitudes held in magnitudes
% clims - optional - a 2 element vector of [cmin, cmax], i.e. the limits
%     for the colormap

% check if we have an axisVec input
if nargin > 1 && ~isempty(axisVec)
    rotInd = true;
else
    rotInd = false;
end

% check if we have a magnitudes input
if nargin > 2 && ~isempty(magnitudes)
    magInd = true;
else
    magInd = false;
end

% check if we have a clims input
if nargin > 3 && ~isempty(clims)
    climInd = true;
else
    climInd = false;
end

% check the number of reefs
nReefs = length(GBRShape);
hold on

% initialise storage for each of the centroids
x = zeros(nReefs, 1);
y = zeros(nReefs, 1);

% use a for loop to store each centroid
for r = 1:nReefs
    x(r) = GBRShape(r).Centroid(1);
    y(r) = GBRShape(r).Centroid(2);
end

% if we have an axisVec input, rotate it and make a change of basis for a
% second set of reef centroid
if rotInd

    % normalise axisVec
    basisVec1 = axisVec / norm(axisVec);

    % check it is of the correct orientation
    if size(basisVec1, 2) > size(basisVec1, 1)
        basisVec1 = basisVec1';
    end

    % rotate axisVec -90 degrees to form the second basis vector
    rotMat = [0, 1; -1, 0];
    basisVec2 = rotMat * basisVec1;

    % now form the new basis matrix, which will then be used to rotate the
    % list of centroids
    basisMat = [basisVec2, basisVec1];
    resMat = basisMat \ cat(1, x', y');
    x2 = resMat(1, :)';
    y2 = resMat(2, :)';

    % plot translated coordinates in red
    plot(x2, y2, '.', 'Color', getColour('r'));

end

% plot results in blue if magnitudes were not inputted
if ~magInd

    % if magnitudes not present, just plot all in blue
    plot(x, y, '.', 'Color', getColour('b'));

else

    % otherwise, do some matlab wizardry to plot thing with a colormap
    scatter(x, y, 10, magnitudes, 'filled')

    % specify colormap, clim and add a colorbar
    colormap(myColourMap())
    if climInd
        clim(clims)
    end
    colorbar

end

set(gca, 'FontName', 'Times')

end