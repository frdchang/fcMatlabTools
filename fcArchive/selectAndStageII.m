function [ MLEs,candidates ] = selectAndStageII(photonData, estimated,camVar,Kmatrix,psfObjs,varargin)
%SELECTANDSTAGEII wraps both select candidations and stageii 

%--parameters--------------------------------------------------------------
params.strategy     = 'otsu';
params.numSpots     = 2;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

candidates = selectCandidates(estimated,params);
% plot3Dstack(candidates.L);
% candidatesSep = selectCandidates(estimatedSep);
MLEs = findSpotsStage2V2(photonData,camVar,estimated,candidates,Kmatrix,psfObjs,params);

end

