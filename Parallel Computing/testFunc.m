% just want to use this to try stuff on the hpc

% first, just try to open a parallel pool and run something relatively
% useless

% ensure parallel processes are cancelled
if exist('futureVec', 'var')
    cancelFutureVec(futureVec);
    clear futureVec
end

% run in parallel
for i = 1:20
    futureVec(i) = parfeval(@testFuncParallel, 1);
end

% determine the number of workers
test = gcp;
numWorkers = test.NumWorkers;

% extract results
finishedInd = false;
errorInd = false;
while ~finishedInd && ~errorInd
    [finishedInd, errorInd] = checkFutureVec(futureVec, 'noPrint');
    if finishedInd
        for i = 1:20
            outputTest{i} = fetchOutputs(futureVec(i));
        end
        clear futureVec
    end
    pause(10)
end

% % save the data we want
% if finishedInd
%     if ~isfolder("outputs")
%         mkdir outputs
%     end
%     save outputs\testData.mat
% end