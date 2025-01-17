function goto(locName)
% goto() will simply cd into different projects of mine, for ease of access

% inputs:

% locName - indicates the project to load into, could be "cotsEnsemb",
    % "cotsConnAnal", "dispVar", "specRichness"

% if no location name is given, display the names I actually use
if nargin == 0
    fprintf("cotsEnsemb, cotsEnsemble, COTSEnsemble\n")
    fprintf("cotsConnAnaly\n")
    fprintf("specRichness\n")
    fprintf("cotsOutbreakPred\n")
    return
end

% just cd around
if locName == "dispVar"
    try
        cd("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
            "\Research Assistant Work\Dispersal Variability\Code")
    catch

    end
elseif locName == "cotsEnsemb" || locName == "cotsEnsemble" ...
        || locName == "COTSEnsemble"
    try
        cd("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
            "\Research Assistant Work\COTS Ensemble\Code")
    catch
        cd("F:\OneDrive - Queensland University of Technology" + ...
            "\Research Assistant Work\COTS Ensemble\Code")
    end
elseif locName == "cotsConnAnaly"
    try
        cd("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
            "\PhD\COTS Connectivity Analysis\Code")
    catch
        cd("F:\OneDrive - Queensland University of Technology\PhD\" + ...
            "COTS Connectivity Analysis\Code")
    end
elseif locName == "specRichness"
    try
        cd("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
            "\Research Assistant Work\Species Richness Estimation\Code")
    catch

    end
elseif locName == "cotsOutbreakPred"
    try
        cd("C:\Users\sowen\OneDrive - Queensland University of Technology" + ...
            "\PhD\COTS Outbreak Prediction\Code")
    catch
        piss
    end
end

end
