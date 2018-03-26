function [ ] = procPart3(expFolder,varargin )
%PROCPART3 Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% load processed state from previous processing
saveFile = strcat(expFolder,filesep,'processingState');
saveFile = [saveFile '.mat'];
saveFile = createProcessedDir(saveFile);
load(saveFile);

trackedSpots        = procSpotTracking(ec_T_stageIIOutputs,'searchDist',20,'spotthresh',spotThresholds.thresholds);
ec_T_3Dviz          = proc3DViz(eC_T_spotOutputs,eC_T_stageIOutputs,ec_T_stageIIOutputs,eC_T_qpmOutputs,'spotthresh',spotThresholds.thresholds);
analyzedTracks      = procAnalyzeTracks(eC_T_spotOutputs,ec_T_3Dviz,trackedSpots);

end

