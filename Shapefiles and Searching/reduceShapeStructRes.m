function shapeLR = reduceShapeStructRes(shape, pointGap)
% reduceShapeStructRes() will reduce the resolution of a shape file, by
% taking every pointGap^th point

% inputs:

% shape - a shapeStruct with the fields X and Y for the X and Y coordinates
    % of each individual polygon
% pointGap - the number of points between each recorded points in the lower
    % resolution copy produced

% note - won't always take the pointGap^th point - will do so in most
% cases, but for shapes with a low number of points in the first place, we
% should use a smaller gap

% copy over the shapeStruct
shapeLR = shape;

% loop over each of the shapes
for s = 1:length(shape)

    % find the location of the NaNs in the coordinates
    nanInds = find(isnan(shape(s).X));
    if isempty(nanInds)

        % if there are no NaNs, the shape is contiguous without holes - in
        % this case, retain the start and endpoints, and sample only every
        % pointGap^th point
        nPoints = length(shape(s).X);
        if nPoints < 10
            continue
        end
        shapeLR(s).X = [shape(s).X(1), shape(s).X(2:pointGap:(nPoints ...
            - 1)), shape(s).X(end)];
        shapeLR(s).Y = [shape(s).Y(1), shape(s).Y(2:pointGap:(nPoints ...
            - 1)), shape(s).Y(end)];

    else

        % if there are NaNs, need to replicate the above, but for every gap
        % between points with NaNs - to do so will need a cell array
        lineVals = cell(length(nanInds), 2);

        % loop over the individual lines
        lineStart = 1;
        for l = 1:length(nanInds)

            % set the end of the line
            lineEnd = nanInds(l) - 1;

            % if the line has enough points, split it up
            if lineEnd - lineStart + 1 < max(10, pointGap)
                lineVals{l, 1} = shape(s).X(lineStart:lineEnd);
                lineVals{l, 2} = shape(s).Y(lineStart:lineEnd);
            else
                lineVals{l, 1} = [shape(s).X(lineStart), shape(s).X( ...
                    (lineStart + 1):pointGap:(lineEnd - 1)), ...
                    shape(s).X(lineEnd)];
                lineVals{l, 2} = [shape(s).Y(lineStart), shape(s).Y( ...
                    (lineStart + 1):pointGap:(lineEnd - 1)), ...
                    shape(s).Y(lineEnd)];
            end

            % reset the start of the line
            lineStart = nanInds(l) + 1;

        end

        % need to now add the NaNs back in 
        xPoints = [];
        yPoints = [];
        for l = 1:size(lineVals, 1)
            xPoints = [xPoints, lineVals{l, 1}, NaN];
            yPoints = [yPoints, lineVals{l, 2}, NaN];
        end
        shapeLR(s).X = xPoints;
        shapeLR(s).Y = yPoints;

    end

end

end