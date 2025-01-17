function writePbsScript(jobName, commandString, nCPUs, memory, walltime, ...
    writePath, execPath, matlabVer)
% writePbsScript() does what it says on the tin - it will set up a fun
% little batch job script that will run stuff on the HPC, using PBS options
% etc

% inputs:

% jobName - the name applied to the job in both the scheduler, along with
    % potentially the saved data
% commandString - the command to run, e.g. funcName(true, var1, "yes"),
    % could also be a string array, in which case statements are run in
    % batch mode separately
% nCPUs - the number of cores required as an integer
% memory - the amount of memory required in GBs
% walltime - the walltime required in hh:mm
% writePath - optional - the path where the .pbs script will be saved to -
    % default is "", a.k.a. saves to matlab's pwd
% execPath - optional - the path in which to cd into for execution of the
    % pbs script - default is to use the $PBS_O_WORKDIR, i.e. where the
    % script was called from
% matlabVer - optional - a string describing the version of matlab to be
% loaded and used, e.g. "2023b" - default is "2023a"

% set defaults
if nargin < 6 || isempty(writePath)
    writePath = "";
end
if nargin < 7 || isempty(execPath)
    execPath = "$PBS_O_WORKDIR";
end
if nargin < 8 || isempty(matlabVer)
    matlabVer = "2023a";
end

% initialise storage for the code lines
lines = [];

% write the line of code that runs a bash login shell
lines = [lines; "#!/bin/bash -l"; ""];

% name the job
lines = [lines; "#PBS -N " + jobName];

% set the number of CPUs and memory, along with the walltime
lines = [lines; "#PBS -l select=1:ncpus=" + nCPUs + ":mem=" + memory + ...
    "gb"; "#PBS -l walltime=" + walltime + ":00"];

% merge the error and output scripts, and name them the same as the jobName
% to avoid confusion
lines = [lines; "#PBS -j oe"; "#PBS -o " + jobName + ".out"];

% if desired, send an email when the job is completed or aborted - going to
% just leave this for now however
% lines = [lines; "#PBS -m ae"];

% going to echo here that the job has started
lines = [lines; ""; "echo"; "echo  ""started job: " + jobName + """"; ...
    "echo"];

% change the directory to the desired folder for execution
lines = [lines; ""; "cd " + execPath];

% add a command to the end of the commandString that will print out the job
% completion (so I know that all the matlab stuff was actually executed)
if size(commandString, 1) > size(commandString, 2)
    commandString = commandString';
end
commandString = [commandString, "fprintf(""matlab execution successful " + ...
    "for: " + jobName + "\\n"")"];

% if any of the commands don't have a ";" at the end, add them
for i = 1:length(commandString)
    if ~contains(commandString(i), ";")
        commandString(i) = commandString(i) + ";";
    end
end

% load the matlab module then open it, and add in all the desired commands
lines = [lines; "module load matlab/" + matlabVer];
if matlabVer == "2018a"
    lines = [lines; "matlab -nojvm -nodisplay -nosplash -r '" ...
    + strjoin(commandString, " ") + " quit'"];
else
    lines = [lines; "matlab -nojvm -nodisplay -nosplash -batch '" ...
    + strjoin(commandString, " ") + "'"];
end

% going to echo here that the job has ended
lines = [lines; ""; "echo"; "echo  ""finished job: " + jobName + """"; ...
    "echo"];

% add some new lines onto each of the strings
lines = lines + "\n";

% name the file .pbs at the end to show that it's a job script
fileName = jobName + ".pbs";

% open the file
fileID = fopen(writePath + fileName, 'w');

% join the strings and then print them to the file we opened
fprintf(fileID, strjoin(lines, ""));
fclose(fileID);

end