function dataOut = sampleVec(data, sampleAmt)
% randSample() will take a random sample of the input data data, of length
% sampleAmt

% inputs:

% data - a vector of values to sample from
% sampleAmt - the amount of values to sample out, either in integer form,
    % or as a proportion

% output:

% dataOut - a random subset of data

% determine the number of points to sample
if sampleAmt < 1
    sampleAmt = ceil(length(data) * sampleAmt);
end

% take a random sample of them
dataOut = data(randi(length(data), 1, sampleAmt));

end