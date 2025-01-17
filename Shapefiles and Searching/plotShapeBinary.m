function plotShapeBinary(binaryVals, shapeStruct, legendText, ...
    areaTol, areaMarkerSize)
% plotShapeBinary will simply plot either a shape file or a set of
% centroids, colour coded by a binary vector

% NOTE: this function is dumb and you can just use plotShapes() to do all
% this

% inputs:

% binaryVals - a binary vector for each shape/centroid
% shapeStruct - a shape structure or set of centroids with n entries, which
%     each contain the fields X and Y holding the x and y points for the
%     outlines of each reef or centroids in the order [X, Y] alternatively
% legendText - optional - a 2 element string vector containing the legend
%     labels for the binaryVals == 1 case first - default is
%     ['True', 'False']
% areaTol - optional - if specified, will represent the area at below
%     which, MPA choices for filled polygons will be marked with a circle -
%     defualt is inf
% areaMarkerSize - optional - connected to above, controls markersize for
%     the circles used for small area reefs - default is 4

% set default for legendText
if nargin < 4 || isempty(legendText)
    legendText = ["True", "False"];
end

% set default for areaTol
if nargin < 5 || isempty(areaTol)
    areaTol = inf;
end

% set default for areaMarkerSize
if nargin < 6 || isempty(areaMarkerSize)
    areaMarkerSize = 4;
end

% turn binaryVals into a column vector if necessary
if size(binaryVals, 1) > size(binaryVals, 2)
    binaryVals = binaryVals';
end

% check if we are using a shape structure or a set of centroids
if isa('shapeStruct', 'double')
    centroids = shapeStruct;
    shapeVar = false;
else
    shapeVar = true;
end

% won't create a figure in here, will just plot
hold on

% plot some dummy points for the legends to start
plot(shapeStruct(1).Centroid(1), shapeStruct(1).Centroid(2), '.', 'Color', ...
    getColour('g'), 'MarkerSize', 15)
plot(shapeStruct(1).Centroid(1), shapeStruct(1).Centroid(2), '.', 'Color', ...
    getColour('r'), 'MarkerSize', 15)
plot(shapeStruct(1).Centroid(1), shapeStruct(1).Centroid(2), '.', 'Color', ...
    [1, 1, 1], 'MarkerSize', 15)

% check what we are plotting
if ~shapeVar

    % if using centroids, plot them
    falseVals = find(~binaryVals);
    trueVals = find(binaryVals);
    plot(centroids(trueVals, 1), centroids(trueVals, 2), '.', 'Color', ...
        getColour('g'), 'MarkerSize', 10)
    plot(centroids(falseVals, 1), centroids(falseVals, 2), '.', 'Color', ...
        getColour('r'), 'MarkerSize', 10)

else

    % if using a shapeStruct, plot the filled outlines of the shapes
    for r = 1:length(binaryVals)
        if binaryVals(r) == 1
            fill(shapeStruct(r).X(1:(end-1)), shapeStruct(r).Y(1:(end-1)), ...
                getColour('g'), 'EdgeColor', 'none')
            if areaTol < inf && shapeStruct(r).Area < areaTol
                plot(shapeStruct(r).Centroid(1), shapeStruct(r).Centroid(2), 'o', ...
                    'color', getColour('g'), 'MarkerSize', areaMarkerSize, ...
                    'LineWidth', 0.6)
            end
        else
            fill(shapeStruct(r).X(1:(end-1)), shapeStruct(r).Y(1:(end-1)), ...
                getColour('r'), 'EdgeColor', 'none')
        end
    end

end

% also throw in a guide just in case
legend(legendText)

% throw in some axes labels, assuming shape structure in longitude and
% latitude
xlabel('Longitude')
ylabel('Latitude')

% set axes equal because I'm not a godless savage
axis equal

% set the test to tnr (again because I'm not a godless savage)
set(gca, 'FontName', 'Times')

end
