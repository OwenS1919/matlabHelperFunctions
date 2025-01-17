function writeHpcCode(jobName, scriptName, nCPUs, memory, walltime, ...
    saveData)
% writeHPCCode() does what it says on the tin - it will set up a fun little
% batch job script that will run stuff on the HPC, using PBS options etc

% NOTE: this code has now be updated and is instead called writePbsScript()

% inputs:

% jobName - the name applied to the job in both the scheduler, along with
    % potentially the saved data
% scriptName - the name of the script and/or function to run, in string
    % form - could also contain inputs e.g. funcName(true, var1, "yes") etc
% nCPUs - the number of cores required as an integer
% memory - the amount of memory required in GBs
% walltime - the walltime required in hh:mm
% saveData - optional - specify as "saveData" if the data is to be saved
    % OUTSIDE the scope of the script/function run - that is, data will be
    % saved by the jobName once the script/function has run - default is
    % "no"

% set defaults
if nargin < 6 || isempty(saveData)
    saveData = "no";
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

% change the directory to the directory from which the job was submitted,
% NOT the folder in which the job is held
lines = [lines; ""; "cd $PBS_O_WORKDIR"];

% load in matlab, then open it - noting that after this point in the code,
% we are inside a matlab command line interface
if saveData == "saveData"
    lines = [lines; "module load matlab"; "matlab -nojvm -nodisplay " + ...
        "-nosplash -batch '" + scriptName + "; cd outputs; save " ...
        + jobName + ".mat'"];
else
    lines = [lines; "module load matlab"; "matlab -nojvm -nodisplay " + ...
        "-nosplash -batch '" + scriptName + "'"];
end

% add some new lines onto each of the strings
lines = lines + "\n";

% name the file .pbs at the end to show that it's a job script
fileName = jobName + ".pbs";
fileID = fopen(fileName, 'w');

% join the strings and then print them to the file we opened
fprintf(fileID, strjoin(lines, ""));
fclose(fileID);

% let's now print the code to console that will transfer this job script
% over to the HPC

% maybe I ceebs here, but will need to think about how to copy things over
% to the specific project directory methinks, along with the necessary
% files etc

% will obviously need to be ensuring that any children functions are also
% copied over, which is the main issue here - could perhaps make a separate
% function that can write the scp code required as well

% fprintf("scp ")

end