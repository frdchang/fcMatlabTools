function [] = procPart1(expFolder,varargin)
%PROCPART1 Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.camVarFile               = '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';
params.specimenUnitsInMicrons   = [0.1083,0.1083,0.389];
params.gaussKernSigmaSqs        = {[0.9,0.9,0.9]};%{[0.9,0.9,0.9],[1,1,1]};
params.gaussPatchSizes          = {[7 7 7]};%{[7 7 7],[7 7 7]};
params.Kmatrix                  = 1;%[1 0.31; 0 1];
params.channels                 = {'FITC\(WhiteTTL\)'};%{'FITC\(WhiteTTL\)','mCherry\(WhiteTTL\)'};
params.useCluster               = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if params.useCluster
    qpmOutputsParallel      = {'setWallTime','00:55:00','setMemUsage','4000','useBatchWorkers',true,'doProcParallel',true};
    xyAlignmentsParallel    = {'setWallTime','01:20:00','setMemUsage','4000','useBatchWorkers',true,'doProcParallel',true};
    stageIOutputsParallel   = {'setWallTime','01:20:00','setMemUsage','4000','useBatchWorkers',true,'doProcParallel',true};
    maxColoredProjsParallel = {'setWallTime','01:20:00','setMemUsage','4000','useBatchWorkers',true,'doProcParallel',true};
    xyMaxProjNDsParallel    = {'setWallTime','01:20:00','setMemUsage','4000','useBatchWorkers',true,'doProcParallel',true};
    T_stageIOutputsParallel = {'setWallTime','01:20:00','setMemUsage','4000','useBatchWorkers',true,'doProcParallel',true};
else
    qpmOutputsParallel      = {'doProcParallel',true};
    xyAlignmentsParallel    = {'doProcParallel',true};
    stageIOutputsParallel   = {'doProcParallel',true};
    maxColoredProjsParallel = {'doProcParallel',true};
    xyMaxProjNDsParallel    = {'doProcParallel',true};
    T_stageIOutputsParallel = {'doProcParallel',true};
end

camVarFile              = params.camVarFile;
specimenUnitsInMicrons  = params.specimenUnitsInMicrons;
psfObjs                 = cellfunNonUniformOutput(@(x,y) genGaussKernObj(x,y),params.gaussKernSigmaSqs,params.gaussPatchSizes);
Kmatrix                 = params.Kmatrix;
channels                = params.channels ;

phaseOutputs        = procGetImages(expFolder,'BrightFieldTTL','phaseOutputs',specimenUnitsInMicrons);
spotOutputs         = procGetImages(expFolder,channels,'spotOutputs',specimenUnitsInMicrons);

qpmOutputs          = procQPMs(phaseOutputs,'negateQPM',false,qpmOutputsParallel{:});
xyAlignments        = procXYAlignments(qpmOutputs,'imgTableName','genQPM1',xyAlignmentsParallel{:});

stageIOutputs       = procStageI(spotOutputs,psfObjs,'Kmatrix',Kmatrix,'stageIFunc',@findSpotsStage1V2,'camVarFile',camVarFile,stageIOutputsParallel{:});

maxColoredProjs     = procProjectStageI(stageIOutputs,'projFunc',@maxColoredProj,'projFuncArg',{3},maxColoredProjsParallel{:});
xyMaxProjNDs        = procProjectStageI(stageIOutputs,'projFunc',@xyMaxProjND,'projFuncArg',{},xyMaxProjNDsParallel{:});

T_stageIOutputs     = procXYTranslate(xyAlignments,stageIOutputs,T_stageIOutputsParallel{:});
T_maxColoredProjs   = procXYTranslate(xyAlignments,maxColoredProjs,T_stageIOutputsParallel{:});
T_xyMaxProjNDs      = procXYTranslate(xyAlignments,xyMaxProjNDs,T_stageIOutputsParallel{:});
T_qpmOutputs        = procXYTranslate(xyAlignments,qpmOutputs,T_stageIOutputsParallel{:});
T_spotOutputs       = procXYTranslate(xyAlignments,spotOutputs,T_stageIOutputsParallel{:});
T_phaseOutputs      = procXYTranslate(xyAlignments,phaseOutputs,T_stageIOutputsParallel{:});

%-----USER-----------------------------------------------------------------
thresholdOutputs    = procSelectThreshold(stageIOutputs,'selectField','LLRatio');
edgeProfileZs       = procGetEdgeProfileZ(T_phaseOutputs,'end');
%--------------------------------------------------------------------------

end

