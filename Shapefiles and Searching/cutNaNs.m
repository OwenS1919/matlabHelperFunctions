function x = cutNaNs(x, allNaNs)
% cutNaNs will simply shorten arrays which contain a NaN value at the end,
% used for plotting shape files mainly

% can also be used to just remove all the NaNs from an array if the allNaNs
% is set to "allNaNs"

% input:

% x - input 1D array
% allNaNs - optional - set to "allNaNs" if all of the NaNs in the array are
    % to be removed, not just the one at the end - default is "no"

% output:

% x - same as input, however with final value removed if NaN

% set a default for allNaNs
if nargin < 2 || isempty(allNaNs)
    allNaNs = "no";
end

% remove the NaN at the end of the array (if it exists)
if isnan(x(end))
    x = x(1:end-1);
end

% if we just care about that we are done
if allNaNs ~= "allNaNs"
    return
end

% otherwise, get rid of them all
x = x(~isnan(x));

end
