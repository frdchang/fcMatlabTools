function spotParamStruct = findSpotsStage3(data,gaussSigmas,readNoise,detected,candidates,varargin)
%FINDSPOTSSTAGETHREE applies iterative MLE to each candidates.
% 
% data:             dataset
% gaussSigmas:      [sigmax,sigmay,sigmaz,...]
% candidates:       output from findSpotsStage2
% detected:         output struct from findSpotsStage1
% spotParamStruct:  spot information per candidates
%
% [param cascade] -> MLEbyIteration

%--parameters--------------------------------------------------------------
params.maxNumSpots  = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% apply iterative MLE to every candidate
numCandidates = numel(candidates.stats);
for i = 1:numCandidates
    currStats   = candidates.stats(i);
    % extract relevant data and its domain
    currData        = data(currStats.PixelIdxList);
    currReadNoise   = readNoise(currStats.PixelIdxList);
    currDomains     = num2cell(currStats.PixelList,1)';
    % define theta0
    maxIdx              = find(detected.LLRatio==max(detected.LLRatio(currStats.PixelIdxList)),1);
    maxIdxInPixelList   = find(maxIdx==currStats.PixelIdxList);
    A1est  = detected.A1(maxIdx);
    B1est  = detected.B1(maxIdx);
    B0est  = detected.B0(maxIdx);
    XYZest = {cellfun(@(x) x(maxIdxInPixelList),currDomains)};
    theta0 = {XYZest{:},gaussSigmas(:)};
end

state = MLEbyIteration(data,theta0,readNoise,domains,type,params{:});
