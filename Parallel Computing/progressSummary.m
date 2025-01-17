function [jobsRunning, jobsQueued, successfulJobs, unsuccessfulJobs, ...
    unqueuedJobs] = progressSummary(taskName, writeCodeInd, printInd)
% progressSummary() will do a big ol' summary of all that is going on for a
% specific task, e.g. calculating the connectivity matrices

% inputs:

% taskName - a suffix used to describe the task at hand, "CCS" for
    % calculating cotsStructs, "CCM" for calculating connectivity matrices,
    % and "CPR" for calculating the number of particles released
% codeInd - optional - specify as "writeCode" and this function will write
    % out the code required to gather the necessary data - default is ""
% printInd - optional - specify as "print" and this function will print the
    % results to console - default is "print"

% outputs:

% jobsRunning - a string array containing the jobs which are currently
    % running
% jobsQueued - a string array containing the jobs which are currently
    % queue
% successfulJobs - a string array containing the job names that completed
    % successfully
% unsuccessfulJobs - a string array containing the job names that did not
    % finish or encountered errors that aren't currently running or queued
% unqueuedJobs - a string array containing jobs which haven't been run and
    % aren't currently queued or running

% set a default for writeCodeInd
if nargin < 2 || isempty(writeCodeInd)
    writeCodeInd = "";
end

% set a default for printInd
if nargin < 3 || isempty(printInd)
    printInd = "print";
end

% first, write out the code needed if necessary
if writeCodeInd == "writeCode"
    fprintf("qstat -f > qstatOutput.txt\n")
    fprintf("cat *out > outputCat" + taskName + ".txt\n")
    fprintf("ls *pbs > pbsLs" + taskName + ".txt\n")
    return
end

% run the code that looks at the queue
[jobsRunning, jobsQueued] = qstatSummary("noPrint");

% run the code that looks at the the outputs
[successfulJobs, unsuccessfulJobs] = outputSummary(taskName, "noPrint");

% now, I need to also have a look at the jobs that don't have outputs, so
% that I can determine which haven't been queued nor run yet
outputLs = readlines("pbsLs" + taskName + ".txt");
outputLs = outputLs(1:(end-1));

% annoyingly, I need to remove the .pbs suffix from the stuff in outputLs
for i = 1:length(outputLs)
    var1 = split(outputLs(i), ".");
    outputLs(i) = string(var1{1});
end

% ok, so - let's first remove any files from the unsuccessfulJobs array, if
% they are currently queued or running
queuedOrRunning = union(jobsRunning, jobsQueued);
unsuccessfulJobs = setdiff(unsuccessfulJobs, queuedOrRunning);

% now, we need to grab any of the jobs which haven't been deemed
% successful, unsuccessful, running, or queued
unqueuedJobs = setdiff(outputLs, union(union(queuedOrRunning, ...
    successfulJobs), unsuccessfulJobs));

% now, print all that stuff
if printInd == "print"
    fprintf("\njobs runnning:\n\n")
    for i = 1:length(jobsRunning)
        fprintf(jobsRunning(i) + "\n")
    end
    fprintf("\n")
    fprintf("jobs queued:\n\n")
    for i = 1:length(jobsQueued)
        fprintf(jobsQueued(i) + "\n")
    end
    fprintf("\n")
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
    fprintf("unqueued jobs:\n\n")
    for i = 1:length(unqueuedJobs)
        fprintf(unqueuedJobs(i) + "\n")
    end
    fprintf("\n")
    fprintf("to queue the unsuccessful jobs:\n\n")
    for i = 1:length(unsuccessfulJobs)
        fprintf("qsub " + unsuccessfulJobs(i) + ".pbs\n")
    end
    fprintf("\n")
    fprintf("to queue the unqueued jobs:\n\n")
    for i = 1:length(unqueuedJobs)
        fprintf("qsub " + unqueuedJobs(i) + ".pbs\n")
    end
    fprintf("\n")
end

end