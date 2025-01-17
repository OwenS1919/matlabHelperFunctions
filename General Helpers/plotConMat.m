function plotConMat(conMat, centroids, colourMap, symmetricInd)
% plotConMat() will visualise a connectivity matrix

% inputs:

% conMat - the connectivity matrix to be visualised
% centroids - the centroids of the reefs
% colourmap - optional - a string indicating the colourmap style to use, 
    % with options including my version of turbo, halfturbo, and the option 
    % to select a number of colours in sequence with their colour codes
    % separated by the number 2 - default is turbo
% symmetryInd - optional - a string indicating whether the connectivity
    % matrix is symmetric using "symmetric", if so then lines will no
    % longer be curved nor have a directional component

% set a defualt for colourMap
if nargin < 3 || isempty(colourMap)
    colourMap = "halfTurbo";
end

% set a default for symmetryInd
if nargin < 4 || isempty(symmetricInd)
    symmetricInd = "asymmetric";
end

% determine the maximum connectivity value in the area
minConn = min(min(conMat));
maxConn = max(max(conMat));

% loop through the connections, and gathers the
% values and indices of those we care about for both reef-to-reef
% connections and local retention values
indMat = [];
conVals = [];
indMatLoc = [];
conValsLoc = [];
nReefs = size(conMat, 1);
for i = 1:nReefs
    for j = 1:nReefs
        if conMat(i, j) > 0
            if i ~= j
                indMat = [indMat; i, j];
                conVals = [conVals, conMat(i, j)];
            else
                conValsLoc = [conValsLoc, conMat(i, j)];
            end
        end
    end
end

% set up the plot
hold on

% let's now plot all of the nonzero connectivities
minArrowSize = 4;
maxArrowSize = 6;
minLW = 0.5;
maxLW = 1.5;
[~, order] = sort(conVals, "ascend");
conVals = conVals(order);
indMat = indMat(order, :);
headW = 6;
headL = 5;

% doing the below for a colorbar xd
scatter([centroids(1, 1), centroids(1, 1)], [centroids(1, 2), ...
    centroids(1, 2)], 0.01, [0, maxConn]);
colormap(myColourMap(colourMap))
colorbar()

% switch how we plot based on whether the connectivity matrix is symmetric
% or not
if symmetricInd ~= "symmetric"

    % plot the lines so that the strongest connections are on top, and
    % connections are colour coded and thickness based - this code is gross
    % and unwieldy sorry
    for i = 1:length(conVals)

        % calculated the desired line width, then create and plot a curved
        % line with an arrow in the middle
        currCol = getColour(conMat(indMat(i, 1), indMat(i, 2)), ...
            maxConn, colourMap);
        currLW = minLW + (conMat(indMat(i, 1), indMat(i, 2)) / maxConn)^2 ...
            * (maxLW - minLW);
        currArrowSize = minArrowSize + (conMat(indMat(i, 1), indMat(i, 2)) ...
            / maxConn)^2 * (maxArrowSize - minArrowSize);
        curvedLine = createCurvedLine([centroids(indMat(i, 1), 1), ...
            centroids(indMat(i, 1), 2); centroids(indMat(i, 2), 1), ...
            centroids(indMat(i, 2), 2)]);
        plot(curvedLine(:, 1), curvedLine(:, 2), 'color', currCol, ...
            'LineWidth', currLW)
        midInd = ceil(length(curvedLine) / 2);
        % arrowHead = annotation("arrow", "HeadStyle", "cback1",
        % "HeadLength", ...
        %     headL, "HeadWidth", headW, 'LineStyle', 'none');
        arrowHead = annotation("arrow", "HeadStyle", "cback1", "HeadLength", ...
            currArrowSize, "HeadWidth", currArrowSize, 'LineStyle', 'none');
        set(arrowHead, "parent", gca);
        set(arrowHead, "position", [curvedLine(midInd - 1, 1), ...
            curvedLine(midInd - 1, 2), curvedLine(midInd, 1) ...
            - curvedLine(midInd - 1, 1), curvedLine(midInd, 2) ...
            - curvedLine(midInd - 1, 2)])
        set(arrowHead, "LineStyle", "none", "Color", currCol)

    end

else

    % also change the max line thickness here methinks
    minLW = 0.5 ;
    maxLW = 4;

    % plot the lines so that the strongest connections are on top, and
    % connections are colour coded and thickness based - this code is gross
    % and unwieldy sorry
    for i = 1:length(conVals)

        % calculated the desired line width, then create and plot a curved
        % line with an arrow in the middle
        currCol = getColour(conMat(indMat(i, 1), indMat(i, 2)), ...
            maxConn, colourMap);
        currLW = minLW + (conMat(indMat(i, 1), indMat(i, 2)) / maxConn)^2 ...
            * (maxLW - minLW);
        curvedLine = createCurvedLine([centroids(indMat(i, 1), 1), ...
            centroids(indMat(i, 1), 2); centroids(indMat(i, 2), 1), ...
            centroids(indMat(i, 2), 2)]);
        plot([centroids(indMat(i, 1), 1), centroids(indMat(i, 2), 1)], ...
            [centroids(indMat(i, 1), 2), centroids(indMat(i, 2), 2)], ...
            'color', currCol, 'LineWidth', currLW)

    end

end

% plot the self-retention separately -- to do so however, we need to
% determine a radius for the self-retention which I will base on the max
% pdist of the connections
selfRecRad = 0.1 * mean(mean(pdist(centroids)));
thetaVec = linspace(0, 2 * pi, 21);
for r = 1:nReefs
    if conMat(r, r) > 0

        % calculate the current linewidth, colour, and arrow size based on
        % the connectivity strength
        currLW = minLW + (conMat(r, r) / maxConn)^2 ...
            * (maxLW - minLW);
        currCol = getColour(conMat(r, r), maxConn, colourMap);
        currArrowSize = minArrowSize + (conMat(r, r) / maxConn)^2 ...
            * (maxArrowSize - minArrowSize);

        % plot the circle
        % centreCircleX = selfRecRad * cos(thetaVec + reefAngles(r) + pi);
        % centreCircleY = selfRecRad * sin(thetaVec + reefAngles(r) + pi);
        centreCircleX = selfRecRad * cos(thetaVec);
        centreCircleY = selfRecRad * sin(thetaVec);
        % circleCentre = (1 + selfRecRad) * [cos(reefAngles(r)), ...
        %     sin(reefAngles(r))];
        circleCentre = [centroids(r, 1) - selfRecRad, centroids(r, 2)];
        circleX = centreCircleX + circleCentre(1);
        circleY = centreCircleY + circleCentre(2);
        plot(circleX, circleY, 'k', 'lineWidth', currLW, 'color', ...
            currCol)

        % add an arrow in the middle to represent the direction
        mP = round(length(circleX) / 2);
        ah = annotation('arrow', 'headStyle', 'cback1', ...
            'HeadLength', currArrowSize, 'HeadWidth', currArrowSize, ...
            'Color', currCol, 'LineStyle', 'none');
        set(ah, 'parent', gca)
        set(ah, 'position', [circleX(mP), circleY(mP), (circleX(mP) ...
            - circleX(mP+1)), (circleY(mP) - circleY(mP+1))])

    end
end

end