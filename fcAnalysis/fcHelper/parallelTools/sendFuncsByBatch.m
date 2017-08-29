function [batchOutputs,runTimeBasket,counters] = sendFuncsByBatch(myFunc,listOflistOfArguments,numWorkers,varargin)
%SENDFUNCSBYBATCH will send a bunch of myFunc commands parsed by
%listOfFuncArgs.

%--parameters--------------------------------------------------------------
params.pollingPeriod     = 10;
params.numSigmaThresh    = 1;
params.minSamples        = 5;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%% setup cluster stuff
setupCluster(varargin{:});
clusterObj = parcluster;

%% issue the batch commands parsed by listOfFuncArgs
numFuncOutput       = nargout(myFunc);
numBatches          = numel(listOflistOfArguments);
j = cell(numBatches,1);
jobIDX = 1:numBatches;
for ii = jobIDX
    disp(['sendFuncsByBatch(): submitting ' num2str(ii) '/' num2str(numBatches)]);
    j{ii} = clusterObj.batch(myFunc,numFuncOutput,listOflistOfArguments{ii},'pool',numWorkers);
end

%% keep track of failed batch commands and re-issue
pollingPeriod   = params.pollingPeriod;
numSigmaThresh  = params.numSigmaThresh;
minSamples      = params.minSamples;
batchOutputs    = cell(numBatches,1);
alldone         = zeros(numBatches,1);
runTimeBasket   = zeros(numBatches,1);
counter         = 1;
failedCounter   = 0;
slowCounter     = 0;
errorCounter    = 0;

while(true)
    % copy the finished jobs to my output holder
    rel_IDX = cellfun(@(x) isequal(x.State,'finished'),j(jobIDX));
    % get idx of those that have errors
    rel_errorIDX = ~cellfun(@(x) all(cellfun(@isempty,{x.Tasks.ErrorMessage})),j(jobIDX));
    % resubmit jobs with errors
    errorIDX = jobIDX(rel_errorIDX);
    for jj = 1:numel(errorIDX)
        disp(['sendFuncsByBatch(): resubmitting error ' mat2str(errorIDX)]);
        j{errorIDX(jj)}.delete;
        j{errorIDX(jj)} = clusterObj.batch(myFunc,numFuncOutput,listOflistOfArguments{jj},'pool',numWorkers);
        errorCounter = errorCounter + 1;
    end
    % finished with errors do not get updated
    rel_IDX(rel_errorIDX) = 0;
    finishedIDX = jobIDX(rel_IDX);
    batchOutputs(finishedIDX) = cellfunNonUniformOutput(@(x) x.fetchOutputs,j(finishedIDX));
    runTimeBasket(finishedIDX) = cellfun(@calcRunTimeForJob,j(finishedIDX));
    % delete jobs
    cellfun(@(x) x.delete,j(finishedIDX));
    jobIDX(rel_IDX) = [];
    alldone(finishedIDX) = 1;
    % resubmit failed jobs
    failedIDX = jobIDX(cellfun(@(x) isequal(x.State,'failed'),j(jobIDX)));
    for jj = 1:numel(failedIDX)
        disp(['sendFuncsByBatch(): resubmitting failed ' mat2str(failedIDX)]);
        j{failedIDX(jj)}.delete;
        j{failedIDX(jj)} = clusterObj.batch(myFunc,numFuncOutput,listOflistOfArguments{jj},'pool',numWorkers);
        failedCounter = failedCounter + 1;
    end
    % if jobs are all deleted then breaks
    disp(['sendFuncsByBatch(): ' num2str(counter) ' ' num2str(sum(cellfun(@(x) isequal(x.State,'running'),j(jobIDX)))) ' running, ' num2str(sum(cellfun(@(x) isequal(x.State,'pending'),j(jobIDX)))) ' pending, ' num2str(sum(cellfun(@(x) isequal(x.State,'queued'),j(jobIDX)))) ' queued']);
    if all(alldone)
        break;
    end
    % resubmit jobs that are taking too long
    rel_runningIDX = cellfun(@(x) isequal(x.State,'running'),j(jobIDX));
    runningIDX     = jobIDX(rel_runningIDX);
    calcElapsedTime = cellfun(@calcRunTimeForJob,j(runningIDX));
    
    meanRunTime = mean(runTimeBasket(alldone>0));
    stdRunTime  = std(runTimeBasket(alldone>0));
    
    threshTime = meanRunTime + stdRunTime*numSigmaThresh;
    
    if sum(alldone) < minSamples
        threshTime = inf;
    end
    
    slowJobsIDX = calcElapsedTime > threshTime;
    reRunJobsIDX = runningIDX(slowJobsIDX);
    for jj = 1:numel(reRunJobsIDX)
        disp(['sendFuncsByBatch(): resubmitting slow ' mat2str(reRunJobsIDX)]);
        j{reRunJobsIDX(jj)}.delete;
        j{reRunJobsIDX(jj)} = clusterObj.batch(myFunc,numFuncOutput,listOflistOfArguments{jj},'pool',numWorkers);
        slowCounter = slowCounter + 1;
    end
    pause(pollingPeriod);
    counter = counter + 1;
end

% clear jobs in cluster
clusterObj.Jobs.delete

counters.failed = failedCounter;
counters.slow   = slowCounter;
counters.error  = errorCounter;



