function partArr = gridPartition(border, gridDim)
% gridPartRectangle will partition an area represented by border into
% dimensions specified by gridDim

% inputs:

% border – the border of the region for which the partition is to be made,
    % in the form [xMin, xMax, yMin, yMax]
% gridDim – A vector of the dimensions of the grid to be created, in the
    % form [m, n] to create an m (columns) by n (rows) grid

% outputs:

% partArr – a cell array, where each cell contains the x and y coordinates
    % of a partition in the form x = partArr{i}(:, 1), y = partArr{i}(:,
    % 1);

% initialise the partArr
m = gridDim(2);
n = gridDim(1);
totCells = m * n;
partArr = zeros(totCells, 2, 5);

% create a vector of all the possible x and y values, using the border
% matrix as a guide
xVals = linspace(border(1), border(2), n + 1);
yVals = linspace(border(3), border(4), m + 1);

% fill in the x values corresponding to the first row, and then copy them
% into each consecutive row
for i = 1:n
    partArr(i, 1, [1 2 5]) = xVals(i);
    partArr(i, 1, [3 4]) = xVals(i + 1);
end

% copy the above set of x values into each consecutive row
for r = 2:m
    partArr(((r-1)*n + 1):(r*n), 1, :) = partArr(1:n, 1, :);
end

% fill in the y values corresponding to the first column, and then copy
% them into each consecutive column
for i = 1:m
    partArr((i-1)*n + 1, 2, [2 3]) = yVals(i);
    partArr((i-1)*n + 1, 2, [1 4 5]) = yVals(i + 1);
end

% create a vector of the indices in partArr that the first column is
% contained in, in order to more easily access it in the following loop:
indVec = 1:m;
indVec = (indVec-1).*n + 1;

% copy the above set of y values to the following columns
for c = 2:n
    partArr((indVec + c - 1), 2, :) = partArr(indVec, 2, :);
end

% beacuse the above code is old and weird, I'm going to convert the partArr
% back to the form I listed in the function outputs here
temp = cell(totCells, 1);
for c = 1:totCells
    temp{c} = [squeeze(partArr(c, 1, :)), squeeze(partArr(c, 2, :))];
end
partArr = temp;

% also, because my later code is for some stupid reason now failing, I'm
% going to reverse the order of the partArr xd
partArr = partArr(length(partArr):-1:1);

% this didn't work which sucks and is cringe - I need to rearder it in a
% different manner
for r = 1:m

    % someone should actually throw me through a window
    partArr(((r-1)*n + 1):r*n) = partArr(r*n:-1:((r-1)*n + 1));

end

end

