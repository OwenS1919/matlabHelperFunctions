function addPaths()
% just a function I am using to add the paths to all of my custom functions

% check if I'm on my pc or laptop
var1 = pwd;

if var1(1) == "F"

    % add the paths if I'm on my pc
    addpath("F:\OneDrive - Queensland University of Technology\Matlab " + ...
        "Helper Functions\General Helpers");
    addpath("F:\OneDrive - Queensland University of Technology\Matlab " + ...
        "Helper Functions\Parallel Computing");
    addpath("F:\OneDrive - Queensland University of Technology\Matlab " + ...
        "Helper Functions\Shapefiles and Searching");

else

    % add the paths if I'm on my laptop
    addpath("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
        "\Matlab Helper Functions\General Helpers");
    addpath("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
        "\Matlab Helper Functions\Parallel Computing");
    addpath("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
        "\Matlab Helper Functions\Shapefiles and Searching");

end

end