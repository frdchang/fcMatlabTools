function [MLEs] = findSpotsStage2V2(datas,cameraVariances,estimated,candidates,Kmatrix,objKerns,varargin)
%FINDSPOTSSTAGE2V2 will take each candidate and do iterative fitting

%--parameters--------------------------------------------------------------
params.doParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if ischar(cameraVariances)
    [datas,cameraVariances] = returnElectronsFromCalibrationFile(datas,cameraVariances);
end


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
MLEs = cell(numel(ids),1);
if params.doParallel
    initMatlabParallel();
    % pre carve it out
    carvedDatas     = cell(numel(ids),1);
    carvedEstimates = cell(numel(ids),1);
    carvedCamVar    = cell(numel(ids),1);
    carvedMask      = cell(numel(ids),1);
    carvedRectSubArrayIdx = cell(numel(ids),1);
    for ii = 1:numel(ids)
        currMask = candidates.L == ids(ii);
        carvedDatas{ii}             = carveOutWithMask(datas,currMask,sizeKern);
        carvedEstimates{ii}         = carveOutWithMask(estimated,currMask,sizeKern,'spotKern','convFunc');
        carvedCamVar{ii}            = carveOutWithMask(cameraVariances,currMask,sizeKern);
        carvedMask{ii}              = carveOutWithMask(currMask,currMask,sizeKern);
        carvedRectSubArrayIdx{ii}   = candidates.stats(ii).SubarrayIdx;
        carvedEstimates{ii} .spotKern = estimated.spotKern;
    end
    clear('datas','cameraVariances','estimated','candidates');
    setupParForProgress(numel(ids));
    parfor ii = 1:numel(ids)
        incrementParForProgress();
        MLEs{ii} = doMultiEmitterFitting(carvedMask{ii},carvedRectSubArrayIdx{ii},carvedDatas{ii},carvedEstimates{ii},carvedCamVar{ii},Kmatrix,objKerns,params);
    end
else
    for ii = 1:numel(ids)
        currMask = candidates.L == ids(ii);
        carvedDatas             = carveOutWithMask(datas,currMask,sizeKern);
        carvedEstimates         = carveOutWithMask(estimated,currMask,sizeKern,'spotKern','convFunc');
        carvedCamVar            = carveOutWithMask(cameraVariances,currMask,sizeKern);
        carvedMask              = carveOutWithMask(currMask,currMask,sizeKern);
        carvedRectSubArrayIdx   = candidates.stats(ii).SubarrayIdx;
        %     currPixelIdxlist        = candidates.stats(ii).PixelIdxList;
        carvedEstimates.spotKern = estimated.spotKern;
        %     linearDatas             = cellfunNonUniformOutput(@(x) x(candidates.stats(ii).PixelIdxList),datas);
        %     linearDomains           = num2cell(candidates.stats(ii).PixelList,1)';
        MLEs{ii}                = doMultiEmitterFitting(carvedMask,carvedRectSubArrayIdx,carvedDatas,carvedEstimates,carvedCamVar,Kmatrix,objKerns,params);
    end
end


