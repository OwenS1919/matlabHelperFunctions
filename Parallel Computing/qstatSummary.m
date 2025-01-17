function [jobsRunning, jobsQueued] = qstatSummary(printInd)
% qstatSummary() will look at a .txt from a qstat -f call, and print/return
% the names of jobs which are queued and running

% input:

% printInd - optional - specify as "print" and this function will print the
    % results to console - default is "print"

% outputs:

% jobsQueued - a string array containing the jobs which are currently
    % queue
% jobsRunning - a string array containing the jobs which are currently
    % running

% set a default for printInd
if nargin < 1 || isempty(printInd)
    printInd = "print";
end

% first, load in the qstat summary
qstatOutput = readlines("qstatOutput.txt");

% next, set up the outputs
jobsRunning = "";
jobsQueued = "";

% loop over the lines, and stop when you get to one of my jobs
for i = 1:length(qstatOutput)
    if contains(qstatOutput(i), "Job_Owner = xjc01583")
        
        % determine the name of the current job
        jobNameCurr = qstatOutput(i - 1);
        jobNameCurr = split(jobNameCurr, " ");
        jobNameCurr = jobNameCurr{end};

        % determine whether the current job is running, and store the job
        % name accordingly
        if contains(qstatOutput(i + 1), "job_state = Q")
            jobsQueued = [jobsQueued; jobNameCurr];
        elseif contains(qstatOutput(i + 1), "resources") ...
                || contains(qstatOutput(i + 1), "job_state = R")
            jobsRunning = [jobsRunning; jobNameCurr];
        else
            fprintf("error in my code lol\n")
        end

    end
end

% remove the first values in the outputs
jobsRunning = jobsRunning(2:end);
jobsQueued = jobsQueued(2:end);

% becuase I like printing, print a report of the jobs here
if printInd == "print"
    fprintf("jobs runnning:\n\n")
    for i = 1:length(jobsRunning)
        fprintf(jobsRunning(i) + "\n")
    end
    fprintf("\n")
    fprintf("jobs queued:\n\n")
    for i = 1:length(jobsQueued)
        fprintf(jobsQueued(i) + "\n")
    end
    fprintf("\n")
end

end