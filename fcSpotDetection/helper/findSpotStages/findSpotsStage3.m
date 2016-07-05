function spotParams = findSpotsStage3(data,gaussSigmas,readNoise,detected,candidates,varargin)
%FINDSPOTSSTAGETHREE applies iterative MLE to each candidates.
%
% data:             dataset
% gaussSigmas:      [sigmax,sigmay,sigmaz,...]
% candidates:       output from findSpotsStage2
% detected:         output struct from findSpotsStage1
% spotParamStruct:  spot information per candidates
%
% [notes] - spotParams is an empty cell if there are no candidates
%
% [param cascade] -> MLEbyIteration

%--parameters--------------------------------------------------------------
params.maxNumSpots  = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% apply iterative MLE to every candidate
numCandidates = numel(candidates.stats);
spotParams = cell(numCandidates,1);
for i = 1:numCandidates
    currStats   = candidates.stats(i);
    % extract relevant data and its domain
    currData        = data(currStats.PixelIdxList);
    currReadNoise   = readNoise(currStats.PixelIdxList);
    currDomains     = num2cell(currStats.PixelList,1)';
    % define theta0 among subset that is A1 > 0
    posA1s              = detected.A1(currStats.PixelIdxList)>0;
    if sum(posA1s) >0
        maxIdx              = find(detected.LLRatio==max(detected.LLRatio(currStats.PixelIdxList(posA1s))),1);
        maxIdxInPixelList   = find(maxIdx==currStats.PixelIdxList);
        A1est  = detected.A1(maxIdx);
        B1est  = detected.B1(maxIdx);
        B0est  = detected.B0(maxIdx);
        XYZest = {cellfun(@(x) x(maxIdxInPixelList),currDomains)};
        theta0 = num2cell([XYZest{:};gaussSigmas(:);A1est;B1est]);
        % iterative MLE
        spotParams{i} = MLEbyIteration(currData,theta0,currReadNoise,currDomains,params);
    end
end

% curate away those spots that did not converg
badConvergence = cellfun(@(x) isempty(x.logLike),spotParams);
spotParams(badConvergence) = [];



