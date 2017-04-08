function [MLEs] = findSpotsStage2V2(datas,cameraVariances,estimated,candidates,kMatrix,varargin)
%FINDSPOTSSTAGE2V2 will take each candidate and do iterative fitting

%--parameters--------------------------------------------------------------
params.doParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


ids = unique(candidates.L(:));
ids(~isNaturalNum(ids)) = [];

if iscell(estimated.A1)
    if iscell(estimated.spotKern{1})
        sizeKern = cellfun(@(x) numel(x),estimated.spotKern{1});
    else
        sizeKern = size(estimated.spotKern{1});
    end
else
    sizeKern = size(estimated.spotKern);
end

MLEs = cell(numel(ids));

for ii = 1:numel(ids)
    currMask = candidates.L == ids(ii);
    carvedDatas             = carveOutWithMask(datas,currMask,sizeKern);
    carvedEstimates         = carveOutWithMask(estimated,currMask,sizeKern);
    carvedCameraVariances   = carveOutWithMask(cameraVariances,currMask,sizeKern);
    MLEs{ii} = doMultiEmitterFitting(currMask,carvedDatas,carvedEstimates,carvedCameraVariances,kMatrix,params);
end

