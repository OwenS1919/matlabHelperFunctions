function coords = makeRectangle(bottomLeftCorner, topRightCorner)
% makeRectangle() will create a rectange based on the positions of two
% corner points, and return the associated x, y coordinates

% inputs:

% bottomLeftCorner - the bottom left corner of the rectangle, in the form
    % [xMin, yMin]
% topRightCorner - as above, but with [xMax, yMax]

% output:

% coords - the coordinates of the resulting rectangle, where coords(:, 1)
    % holds the x coordinates, and coords(:, 2) holds the y, where the
    % bottom left corner is repeated (for plotting)

% initialise the output
coords = zeros(5, 2);

% form the output
coords(:, 1) = [bottomLeftCorner(1), bottomLeftCorner(1), ...
    topRightCorner(1), topRightCorner(1), bottomLeftCorner(1)]';
coords(:, 2) = [bottomLeftCorner(2), topRightCorner(2), topRightCorner(2), ...
    bottomLeftCorner(2), bottomLeftCorner(2)]';

end