function plotShapeStruct(shapeStruct, colour, vals, fillIn, indices)
% plotshapeStruct will simply plot the shape outlines held in shapeStruct

% NOTE: this code is old and I now use plotShapes() instead which is better
% and has more functionality etc

% inputs:

% shapeStruct - holds the reef outlines in a structure with fields X and Y
%     storing the X and Y coordinates
% colour - optional - specifies the colour code - default is just whatever
%     matlab assigns
% vals - optional - if specified, vals will be used to create a colourmap
%     and control the colours for each reef but only for the fill option -
%     default is "k", i.e. black
% fillIn - optional - specify as "fill" if the shapes are to be filled,
%     "fillBorder" if the borders are also to be coloured, rather than just
%     plotting the outlines - default is "no"
% indices - optional - if specified as "indices" will also plot the indices
%     of each reef at their centroids - default is "" i.e. no indices

% set a default value for indices and colour if not specified
if nargin < 2 || isempty(colour)
    colour = "";
end
if nargin < 3
    vals = [];
end
if nargin < 4 || isempty(fillIn)
    fillIn = "no";
end
if nargin < 5 || isempty(indices)
    indices = "";
end

% determine the number of shapes
nShapes = length(shapeStruct);

% setup the colours array, which will hold the colours each 
colours = zeros(nShapes, 3);
if ~isempty(vals)

    for s = 1:nShapes
        colours(s, :) = getColour(vals(s), max(vals));
    end
    cMap = myColourMap();
    colormap(cMap)

    % need to plot some dummy points to get the colorbar to work
    scatter(shapeStruct(1).X(1), shapeStruct(1).Y(1), 0.00001, min(vals))
    scatter(shapeStruct(1).X(1), shapeStruct(1).Y(1), 0.00001, mean(vals))
    scatter(shapeStruct(1).X(1), shapeStruct(1).Y(1), 0.00001, max(vals))
    colBar = colorbar();
else
    if colour ~= ""
        colourTrip = getColour(colour);
        colours = repmat(colourTrip, [nShapes, 1]);
    else
        for s = 1:nShapes
            colours(s, :) = [0, 0, 0];
        end
    end
end

% turn hold on
hold on

if fillIn ~= "fill" && fillIn ~= "fillIn" && fillIn ~= "fillBorder"

    % if we are not filling each shape, simply loop through and plot
    % outlines
    if isempty(vals)
        for s = 1:nShapes
            plot(shapeStruct(s).X, shapeStruct(s).Y, 'Color', ...
                colours(s, :))
        end
    else
        for s = 1:nShapes
            plot(shapeStruct(s).X, shapeStruct(s).Y, "color", ...
                colours(s, :))
        end
    end
    if indices == "indices"
        for s = 1:nShapes
            text(shapeStruct(s).Centroid(1), ...
                shapeStruct(s).Centroid(2), num2str(s), "FontSize", 15)
        end
    end

elseif fillIn == "fillBorder"

    % otherwise, do the same but filling the shapes and borders
    for s = 1:nShapes
        fill(cutNaNs(shapeStruct(s).X), cutNaNs(shapeStruct(s).Y), ...
            colours(s, :), 'EdgeColor', colours(s, :), "LineWidth", 0.1)
        if indices == "indices"
            text(shapeStruct(s).Centroid(1), ...
                shapeStruct(s).Centroid(2), num2str(s), "FontSize", 15)
        end
    end


else

    % otherwise, do the same but filling the shapes
    for s = 1:nShapes
        fill(cutNaNs(shapeStruct(s).X), cutNaNs(shapeStruct(s).Y), ...
            colours(s, :), 'EdgeColor', 'none')
        if indices == "indices"
            text(shapeStruct(s).Centroid(1), ...
                shapeStruct(s).Centroid(2), num2str(s), "FontSize", 15)
        end
    end

end

% make axis equal 
axis equal

if ~isempty(vals)

    cMap = myColourMap();
    colormap(cMap)

    % need to plot some dummy points to get the colorbar to work
    scatter(shapeStruct(1).X(1), shapeStruct(1).Y(1), 0.00001, min(vals))
    scatter(shapeStruct(1).X(1), shapeStruct(1).Y(1), 0.00001, mean(vals))
    scatter(shapeStruct(1).X(1), shapeStruct(1).Y(1), 0.00001, max(vals))
    colBar = colorbar();

end

% set the fontname to times
fTimes()
end

% added this function in here because it's really simple ahah
function x = cutNaNs(x)
% cutNaNs will simply shorten arrays which contain a NaN value at the end,
% used for plotting shape files mainly

% input:

% x - input 1D array

% output:

% x - same as input, however with final value removed if NaN

if isnan(x(end))
    x = x(1:end-1);
end

end
