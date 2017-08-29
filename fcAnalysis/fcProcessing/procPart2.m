function [] = procPart2(expFolder,varargin )
%PROC Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.useCluster     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if params.useCluster
    cellMasksParallel           = {'setWallTime','00:20:00','setMemUsage','900','useBatchWorkers',1,'doProcParallel',true};
    selectCandsParallel         = {'setWallTime','00:20:00','setMemUsage','900','useBatchWorkers',1,'doProcParallel',true};
    stageIIOutputsParallel      = {'setWallTime','00:20:00','setMemUsage','900','useBatchWorkers',12,'doProcParallel',true,'doParallel',true};
    T_stageIIOutputsParallel    = {'setWallTime','00:20:00','setMemUsage','900','useBatchWorkers',1,'doProcParallel',true};
    T_yeastSegsParallel         = {'setWallTime','00:20:00','setMemUsage','900','useBatchWorkers',12,'doProcParallel',true,'doParallel',true};
    eC_T_stageIOutputsParallel  = {'setWallTime','00:20:00','setMemUsage','900','useBatchWorkers',1,'doProcParallel',true,'doParallel',true};
else
    cellMasksParallel           = {'doProcParallel',true};
    selectCandsParallel         = {'doProcParallel',true};
    stageIIOutputsParallel      = {'doProcParallel',true};
    T_stageIIOutputsParallel    = {'doProcParallel',true};
    T_yeastSegsParallel         = {'doProcParallel',true};
    eC_T_stageIOutputsParallel  = {'doProcParallel',true};
end

% load processed state from previous processing
saveFile = strcat(expFolder,filesep,'processingState');
saveFile = [saveFile '.mat'];
saveFile = createProcessedDir(saveFile);
load(saveFile);

cellMasks           = procThreshPhase(qpmOutputs,'thresholdFunc',@genMaskWOtsu,'phaseTableName','genQPM1',cellMasksParallel{:});
selectCands         = procSelectCandidates(stageIOutputs,thresholdOutputs,'cellMaskVariable','genMaskWOtsu1','cellMasks',cellMasks,'selectField','LLRatio',selectCandsParallel{:});
stageIIOutputs      = procStageII(stageIOutputs,selectCands,stageIIOutputsParallel{:});
T_stageIIOutputs    = procXYTranslateSpots(xyAlignments,stageIIOutputs,T_stageIIOutputsParallel{:});
T_yeastSegs         = procYeastSeg(T_phaseOutputs,T_qpmOutputs,T_edgeProfileZs,'doPlot',false,T_yeastSegsParallel{:});

eC_T_stageIOutputs  = procExtractCells(T_yeastSegs,T_stageIOutputs,eC_T_stageIOutputsParallel{:});
eC_T_qpmOutputs     = procExtractCells(T_yeastSegs,T_qpmOutputs,eC_T_stageIOutputsParallel{:});
eC_T_spotOutputs    = procExtractCells(T_yeastSegs,T_spotOutputs,eC_T_stageIOutputsParallel{:});

ec_T_stageIIOutputs = procExtractSpots(T_yeastSegs,T_stageIIOutputs);

%-----USER-----------------------------------------------------------------
spotThresholds      = procSpotThresholds(stageIIOutputs);
%--------------------------------------------------------------------------
end

