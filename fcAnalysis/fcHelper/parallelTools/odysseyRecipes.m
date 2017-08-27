%% see if i can max out the workers
setupCluster('setWallTime','02:00:00','setMemUsage','4000');
numBatches = 100;
clusterObj = parcluster;
j = cell(numBatches,1);
setupParForProgress(numBatches);
jobIDX = 1:numBatches;
% submit all the jobs
for ii = jobIDX 
   j{ii} = clusterObj.batch(@testParFOr, 1, {256}, 'pool', 12); 
   incrementParForProgress();
end

%% find finished 

pollingPeriod   = 1;
numSigmaThresh  = 3;
minSamples      = 5;
batchOutputs    = cell(numBatches,1);
alldone         = zeros(numBatches,1);
runTimeBasket   = zeros(numBatches,1);

while(true)
    % copy the finished jobs to my output holder
    rel_IDX = cellfun(@(x) isequal(x.State,'finished'),j(jobIDX));
    % get idx of those that have errors 
    rel_errorIDX = ~cellfun(@(x) all(cellfun(@isempty,{x.Tasks.ErrorMessage})),j(jobIDX));
    % resubmit jobs with errors
    errorIDX = jobIDX(rel_errorIDX);
    for jj = 1:numel(errorIDX)
        j{errorIDX(jj)} = clusterObj.batch(@testParFOr, 1, {256}, 'pool', 12); 
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
        j{failedIDX(jj)} = clusterObj.batch(@testParFOr, 1, {256}, 'pool', 12); 
    end
    % if jobs are all deleted then breaks
    disp([num2str(sum(cellfun(@(x) isequal(x.State,'running'),j(jobIDX)))) ' running, ' num2str(sum(cellfun(@(x) isequal(x.State,'pending'),j(jobIDX)))) ' pending, ' num2str(sum(cellfun(@(x) isequal(x.State,'queued'),j(jobIDX)))) ' queued']);
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
        disp(['resubmitting ' mat2str(reRunJobsIDX)]);
        j{reRunJobsIDX(jj)}.cancel;
        j{reRunJobsIDX(jj)} = clusterObj.batch(@testParFOr, 1, {256}, 'pool', 12); 
    end
    pause(pollingPeriod);
end

% clear jobs in cluster
clusterObj.Jobs.delete

%j{1}.Tasks.Error.message
