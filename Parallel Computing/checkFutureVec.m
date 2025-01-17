function [finishedInd, errorInd] = checkFutureVec(futureVec, noPrint)
% parfevalDone() will print a simple message once the futures in futureVec
% have finished running, and return true if all futures have completed
% succesfully, and will display text 

% input:

% futureVec - a vector of parallel.Future objects which are to be checked,
    % alternatively if futureVec is empty, equal to "", or equal to a
    % string, this method will output relevant code to set up if statements
    % for variable extraction
% noPrint - optional - if specified as "noPrint", this function will not
    % print diagnostics to console - default is "print", i.e. prints to
    % console

% output:

% finishedInd - takes value true if all futures have completed succesfully,
    % and false otherwise
% errorInd - takes value true if any future finished with an error

% set default for noPrint
if nargin < 2 || isempty(noPrint)
    noPrint = "print";
end
printInd = noPrint ~= "noPrint";

% print out the relevant code if futureVec is empty or a string
if nargin == 0 || isempty(futureVec)
    fprintf("if checkFutureVec(futureVec)\n    var1 = fetchOutputs(" + ...
        "futureVec(1))\n    clear futureVec\nend\n")
    return
elseif isstring(futureVec)
    fprintf("if checkFutureVec(" + futureVec + ")\n    var1 = fetchOutputs(" + ...
        futureVec + "(1))\n    clear " + futureVec + "\nend\n")
    return
end

% determine the number of futures in futureVec
nFutures = length(futureVec);

% check if any futures haven't finished
ctrFU = 0;
ctrQR = 0;
for i = 1:nFutures
    if futureVec(i).State == "failed" || futureVec(i).State == ...
            "unavailable"
        ctrFU = ctrFU + 1;
    elseif futureVec(i).State == "queued" || futureVec(i).State == ...
            "running"
        ctrQR = ctrQR + 1;
    end
end

% if any of the futures haven't finished, print diagnostic messages and
% return false
if ctrFU > 0 || ctrQR > 0
    if ctrFU > 0
        if printInd
            fprintf("At least one future failed or is unavailable.\n")
        end
        errorInd = true;
    else
        errorInd = false;
    end
    if ctrQR > 0
        if printInd
            fprintf("At least one future is still queued or running.\n")
        end
    end
    finishedInd = false;
    return
end

% check the error states, and print a message if any of the futures
% finished with an error
for i = 1:nFutures
    if ~isempty(futureVec(i).Error)
        if printInd
            fprintf("At least one future finished with an error.\n")
        end
        futureVec(i).Error
        errorInd = true;
        finishedInd = false;
    end
end
if errorInd
    return
end

% if we get to this point, all of the futures ((should)) have completed
% correctly, so we can print a message and return true
if printInd
    fprintf("Futures have completed succesfully.\n")
end
finishedInd = true;
errorInd = false;

end
