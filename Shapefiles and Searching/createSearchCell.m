function searchCell = createSearchCell(partArr, partCell, border, gridDim)
% createSearchCell will create a cell array known as a search cell, which
% will assist in speeding up search times over the reef - i.e. when you
% want to determine whether or not a point lies within a reef

% inputs:

% partArr - a partition array, which contains the coordinates of a number
    % of rectangular blocks used for speeding up searches, in the form n x
    % 2 x 5, where the n refers to the number of blocks present, the 2
    % corresponds to the x and y coordinates, and the 5 corresponds to the
    % points of rectangle, with the origin (bottom left hand corner) twice
% partCell - a cell array, where each cell contains the indices of the
    % reefs contained in the corresponding partition in an array (same
    % order as partArr)
% border – A matrix consisting of two column vectors in the form [xp, yp]
    % which are the respective x and y coordinates of the rectangular
    % domain – this will include the origin twice, and does not need to be
    % in any specific order
% gridDim – A vector of the dimensions of the original grid created, in the
    % form [m, n] where m  = (rows) and n = (columns)

% output:

% searchCell - a cell array which is used to speed up the searching process
    % it follows the following structure - each level has 4 entries -
    % searchCell{3} tells you the current split direction (i.e. "x" or "y")
    % and then searchCell{4} tells you the split value i.e. is pointX >=
    % splitVal - if the point in question has an x or y value above this
    % splitVal, the search continues down searchCell{1} which simply moves
    % down another level, or alternatively searchCell{2} if pointX <
    % splitVal searchCell{3} could also have the values "empty" or
    % "partition", which means that the point does not lie within any reef,
    % or lies within one of the reefs listed in searchCell{4} respectively
    % the only exception is the top layer, which also has the entries
    % searchCell{5} and {6}, which hold the ranges for x and y values
    % covered in the search area respectively, and should a point lie
    % outside these values it does not lie within a reef

% determine the xRange and yRange parameters from the border array
xRange = [min(border(:, 1)), max(border(:, 1))];
yRange = [min(border(:, 2)), max(border(:, 2))];

% determine the xDim and yDim parameters from the gridDim array
xDim = gridDim(2);
yDim = gridDim(1);

% make the first call to the search cell, which will then further be
% recursively called
searchCell = createSearchCellLevel(partArr, partCell, "x", xRange, yRange, ...
    xDim, yDim);

% initialise the last two elements of the first level
searchCell{5} = xRange;
searchCell{6} = yRange;

end
