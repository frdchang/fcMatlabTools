%% see if i can max out the workers
setupCluster('setWallTime','00:10:00','setMemUsage','600');
clusterObj = parcluster;

numBatches = 100;
funcArg = {@testParFOr, 1, {126}, 'pool', 12};
j = cell(numBatches,1);
jobIDX = 1:numBatches;
% submit all the jobs

tic;
for ii = jobIDX 
   j{ii} = clusterObj.batch(funcArg{:}); 
end
toc

%% find finished 

pollingPeriod   = 1;
numSigmaThresh  = 1;
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
        disp(['resubmitting error ' mat2str(errorIDX)]);
        j{errorIDX(jj)}.delete;
        j{errorIDX(jj)} = clusterObj.batch(funcArg{:}); 
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
                        disp(['resubmitting failed ' mat2str(failedIDX)]);
                 j{failedIDX(jj)}.delete;

        j{failedIDX(jj)} = clusterObj.batch(funcArg{:}); 
    end
    % if jobs are all deleted then breaks
%     disp([num2str(sum(cellfun(@(x) isequal(x.State,'running'),j(jobIDX)))) ' running, ' num2str(sum(cellfun(@(x) isequal(x.State,'pending'),j(jobIDX)))) ' pending, ' num2str(sum(cellfun(@(x) isequal(x.State,'queued'),j(jobIDX)))) ' queued']);
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
        disp(['resubmitting slow ' mat2str(reRunJobsIDX)]);
        j{reRunJobsIDX(jj)}.delete;
        j{reRunJobsIDX(jj)} = clusterObj.batch(funcArg{:});
    end
    pause(pollingPeriod);
end

% clear jobs in cluster
clusterObj.Jobs.delete

%j{1}.Tasks.Error.message
