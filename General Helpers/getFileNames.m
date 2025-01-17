function fileNames = getFileNames(dirName, pathStyle)
% getFileNames() will gather the names of all files in a directory

% inputs:

% dirName - optional - specifies the path to the directory in question, can
    % be relative or complete - default is to use the current directory
% pathStyle - optional - specifies the style in which to hold the files,
    % use "fileOnly" for just the names of the files, "path" for the whole
    % path - default is "path"

% outputs:

% fileNames - a string array containing the names (and potentially full
    % paths) of each of the files contained in dirName

% set defaults
if nargin < 1 || isempty(dirName)
    dirName = pwd;
end
if nargin < 2 || isempty(pathStyle)
    pathStyle = "path";
end

% get the current working directory, so we can cd back in later
currDir = pwd;

% cd into the new directory
cd(dirName)

% get the directory thing, remove the bs at the top
dirStruct = dir();
var1 = ([dirStruct(:).isdir] == 0);
nFiles = sum(var1);
fileNames = string(zeros(nFiles, 1));
for i = 1:length(dirStruct)
    fileNames(i) = dirStruct(i).name;
end
fileNames = fileNames(var1);

% if we want the whole path, need to add that in to the fileNames
if pathStyle == "path"
    fileNames = dirStruct(1).folder + "\" + fileNames;
end

% need to cd back
cd(currDir)

end