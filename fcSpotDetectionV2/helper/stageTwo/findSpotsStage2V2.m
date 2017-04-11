function [MLEs] = findSpotsStage2V2(datas,cameraVariances,estimated,candidates,Kmatrix,varargin)
%FINDSPOTSSTAGE2V2 will take each candidate and do iterative fitting

%--parameters--------------------------------------------------------------
params.doParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


ids = unique(candidates.L(:));
ids(~isNaturalNum(ids)) = [];

% if iscell(estimated.A1)
%     if iscell(estimated.spotKern{1})
%         sizeKern = cellfun(@(x) numel(x),estimated.spotKern{1});
%     else
%         sizeKern = size(estimated.spotKern{1});
%     end
% else
%     sizeKern = size(estimated.spotKern);
% end
sizeKern = [0,0,0];
MLEs = cell(numel(ids));
for ii = 1:numel(ids)
    currMask = candidates.L == ids(ii);
    carvedDatas             = carveOutWithMask(datas,currMask,sizeKern);
    carvedEstimates         = carveOutWithMask(estimated,currMask,sizeKern);
    carvedCamVar            = carveOutWithMask(cameraVariances,currMask,sizeKern);
    carvedPixelDomain       = num2cell(candidates.stats(ii).PixelList,1)';
    carvedRectSubArrayIdx   = candidates.stats(ii).SubarrayIdx;
    MLEs{ii}                = doMultiEmitterFitting(carvedRectSubArrayIdx,carvedPixelDomain,carvedDatas,currMask,carvedEstimates,carvedCamVar,Kmatrix,params);
end

