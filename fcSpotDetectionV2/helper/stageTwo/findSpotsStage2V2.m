function [MLEs] = findSpotsStage2V2(datas,cameraVariances,estimated,candidates,Kmatrix,objKerns,varargin)
%FINDSPOTSSTAGE2V2 will take each candidate and do iterative fitting

%--parameters--------------------------------------------------------------
params.doParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if isstruct(candidates)
    
else
    stats = regionprops(candidates,'PixelList','SubarrayIdx','PixelIdxList');
    
    candidatesT.L = candidates;
    candidatesT.stats = stats;
    candidates = candidatesT;
end
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
    carvedMask              = carveOutWithMask(currMask,currMask,sizeKern);
    carvedRectSubArrayIdx   = candidates.stats(ii).SubarrayIdx;
    currPixelIdxlist        = candidates.stats(ii).PixelIdxList;
    carvedEstimates.spotKern = estimated.spotKern;
    linearDatas             = cellfunNonUniformOutput(@(x) x(candidates.stats(ii).PixelIdxList),datas);
    linearDomains           = num2cell(candidates.stats(ii).PixelList,1)';
    MLEs{ii}                = doMultiEmitterFitting(carvedMask,carvedRectSubArrayIdx,carvedDatas,carvedEstimates,carvedCamVar,Kmatrix,objKerns,params);
end

