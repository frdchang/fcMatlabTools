function [ benchStruct ] = procBenchMarkStageIIDirectCluster(benchStruct,varargin)
%PROCBENCHMARKSTAGEII
%--parameters--------------------------------------------------------------
params.doN          = inf;
params.doPlotEveryN = inf;
params.DLLDLambda   = @DLLDLambda_PoissPoiss;
params.setWallTime  = '02:00:00';
params.setMemUsage  = '1800';
params.numWorkers   = 12;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% check if findSpotsStage1 has been done
if ~isfield(benchStruct,'findSpotsStage1V2')
    error('NEED TO RUN STAGE 1 first');
end

% if ~isfield(benchStruct,'selectCandidates')
%     error('NEED TO RUN select Candidates first');
% end

psfObjs         = benchStruct.psfObjs;
psfs            = benchStruct.psfs;
Kmatrix         = benchStruct.Kmatrix;
trueCoor        = benchStruct.centerCoor;
sizeKern        = getPatchSize(psfs{1});
stageIConds     = benchStruct.findSpotsStage1V2;
benchCC         = benchStruct.conditions;

numConditions = numel(stageIConds);
conditions    = cell(size(stageIConds));
disp('procBenchMarkStageIIDirect() starting...');

currStageI = stageIConds;
thetaTrue = cellfunNonUniformOutput(@(x) x.bigTheta,benchCC);
listOflistOfArguments = glueCells(currStageI,thetaTrue);
myFunc = @(currStageIthetaTrue) stageIIhelper(currStageIthetaTrue,params,sizeKern,Kmatrix,psfObjs);
[batchOutputs,runTimeBasket,counters] = sendFuncsByBatch(myFunc,listOflistOfArguments,params.numWorkers,'setWallTime',params.setWallTime,'setMemUsage',params.setMemUsage);
 batchOutputs = vertcat(batchOutputs{:});
%%% need to copy over the outputs
for ii = 1:numConditions
    conditions{ii}.A                = batchOutputs{ii}.currA;
    conditions{ii}.B                = batchOutputs{ii}.currB;
    conditions{ii}.D                = batchOutputs{ii}.currD;
    conditions{ii}.MLEsByDirect     = batchOutputs{ii}.MLEs;
     conditions{ii}.bigTheta         = batchOutputs{ii}.thetaTrue;
    conditions{ii}.saveFiles        = batchOutputs{ii}.myFuncOutSave;
end


disp('procBenchMarkStageIIDirect() finished...');

benchStruct.directFitting  = conditions;
savePath = genProcessedFileName(stageIConds{1}.findSpotsStage1V2{1},@directFitting);
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct','-v7.3');
disp(['saving:' saveFile]);
disp('procBenchMarkStageIIDirect() saved...');
end









