function [successfulJobs, unsuccessfulJobs] = outputSummary(taskName, ...
    printInd)
% outptutSummary() will look at a cat'd set of .out files, and determine
% which scripts rand to completion successfully, and which did not

% taskName - a suffix used to describe the task at hand, "CCS" for
    % calculating cotsStructs, "CCM" for calculating connectivity matrices,
    % and "CPR" for calculating the number of particles released
% printInd - optional - specify as "print" and this function will print the
    % results to console - default is "print"

% outputs:

% successfulJobs - a string array containing the job names that completed
    % successfully
% unsuccessfulJobs - a string array containing the job names that did not
    % finish or encountered errors

% set a default for printInd
if nargin < 2 || isempty(printInd)
    printInd = "print";
end

% first, load in the outputs
outputCat = readlines("outputCat" + taskName + ".txt");

% need to keep track of all the jobs that were started, along with the
% outputs, and the lines in which the jobs started
startedJobs = "";
successfulJobs = "";
unsuccessfulJobs = "";
jobStarts = 0;

% ok, so basically, the way in which we can tell a job completed
% successfully, is when the "finished job" line doesn't start with >>

% I also added something in my code that tells us when the matlab code
% completed successfully without errors etc, but that's not standardised
% so I'm not going to use it here xd

% first, loop over the output lines
for i = 1:length(outputCat)

    % if a job has started, store it
    if contains(outputCat(i), "started job:")
        currJob = split(outputCat(i), " ");
        currJob = currJob{end};
        startedJobs = [startedJobs; currJob];
        jobStarts = [jobStarts; i];
    end

    % if a job has finished successfully, store it
    if contains(outputCat(i), "finished job:") ...
            && ~contains(outputCat(i), ">>")
        
        % first, need to make sure that between the job start and here, we
        % don't have any errors
        errorFound = false;
        for j = jobStarts(end):i
            if contains(outputCat(j), "error") ...
                    || contains(outputCat(j), "Error")
                errorFound = true;
            end
        end
        if ~errorFound
            currJob = split(outputCat(i), " ");
            currJob = currJob{end};
            successfulJobs = [successfulJobs; currJob];
        end
    end

end

% any of the jobs which were started and not finished must have failed, so
% identify them
startedJobs = startedJobs(2:end);
successfulJobs = successfulJobs(2:end);
unsuccessfulJobs = setdiff(startedJobs, successfulJobs);

% now, print all that stuff
if printInd == "print"
    fprintf("successful jobs:\n\n")
    for i = 1:length(successfulJobs)
        fprintf(successfulJobs(i) + "\n")
    end
    fprintf("\n")
    fprintf("unsuccessful jobs:\n\n")
    for i = 1:length(unsuccessfulJobs)
        fprintf(unsuccessfulJobs(i) + "\n")
    end
    fprintf("\n")
end

end