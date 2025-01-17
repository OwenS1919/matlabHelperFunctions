function [partArr, partCell] = trimPartitions(GBRShape, partArr)
% trimPartitions() will remove cells from a partition array which do not
% contain any reefs

% also used for assigning reefs to partitions in partCell

% inputs:

% GBRShape - a structure containing the information from a shape file of
    % the GBR
% partArr – a cell array, where each cell contains the x and y coordinates
    % of a partition in the form x = partArr{i}(:, 1), y = partArr{i}(:,
    % 1)

% outputs:

% partArr - same as original partArr, this time with redundant partitions
    % removed
% partCell - a cell array which holds the indices of each reef which is
    % inside each cell in partArr - i.e. partCell{3} = [23, 56, 89] would
    % indicate that reefs 23, 56 and 89 all exist within the 3rd grid cell
    % in partArr

% determine the number of reefs
nReefs = length(GBRShape);

% determine the number of partitions
nParts = size(partArr, 1);

% make a cell array which holds the reefs contained in each cell - if a
% cell is empty, then we can remove that partition
partCell = cell(nParts, 1);

% convert all of the partitions into polyshapes methinks
partPolys = cell(length(partCell), 1);
for i = 1:length(partCell)
    partPolys{i} = polyshape(partArr{i}(:, 1), partArr{i}(:, 2));
end

% loop over each reef and assign it to a partition cell
for r = 1:nReefs
    
    % determine which grid cell the centroid falls into by looping over all
    % partitions
    currReefPoly = polyshape(GBRShape(r).X, GBRShape(r).Y);
    for p = 1:nParts

        % check if any of the reef's points lie inside this partition using
        % some polyshape subtraction because god is dead and I killed him
        polyIntersect = intersect(currReefPoly, partPolys{p});
        if polyIntersect.NumRegions > 0
            partCell{p} = [partCell{p}, r];
        end
        
    end
    
end

% once all reefs have been assigned, let's remove any cells which have no
% reefs inside them
nonemptyParts = zeros(nParts, 1);
for p = 1:nParts
    if ~isempty(partCell{p})
        nonemptyParts(p) = 1;
    end
end

% now remove any empty partitions
partArr1 = [];
for p = 1:nParts
    if nonemptyParts(p) == 1
        partArr1 = cat(1, partArr1, partArr(p, :, :));
    end
end

% we also need to remove empty cells
partCell(~nonemptyParts) = [];
partArr = partArr1;

end