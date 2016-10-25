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

% currStatBasket = cell(numCandidates,1);
currDataBasket = cell(numCandidates,1);
currNoiseBasket = cell(numCandidates,1);
currDomainBasket = cell(numCandidates,1);
currA1sBasket = cell(numCandidates,1);
currB1sBasket = cell(numCandidates,1);
currB0sBasket = cell(numCandidates,1);
currLLRBasket = cell(numCandidates,1);

for i = 1:numCandidates
    currStats           = candidates.stats(i);
%     currStatBasket{i}   = currStats;
    currDataBasket{i}   = data(currStats.PixelIdxList);
    currNoiseBasket{i}  = readNoise(currStats.PixelIdxList);
    currDomainBasket{i} = num2cell(currStats.PixelList,1)';
    currA1sBasket{i}    = detected.A1(currStats.PixelIdxList);
    currB1sBasket{i}    = detected.B1(currStats.PixelIdxList);
    currB0sBasket{i}    = detected.B0(currStats.PixelIdxList);
    currLLRBasket{i}    = detected.LLRatio(currStats.PixelIdxList);
end

% save memory
params = rmfield(params,'readNoiseVar');
clear('data','readNoise','detected','candidates','varargin');
initMatlabParallel();
setupParForProgress(numCandidates);
parfor i = 1:numCandidates
    % extract relevant data and its domain
    currData        = currDataBasket{i};
%     display([num2str(i) ' ' num2str(numel(currData))]);
    currReadNoise   = currNoiseBasket{i};
    currDomains     = currDomainBasket{i};
    % define theta0 among subset that is A1 > 0
    A1s             = currA1sBasket{i};
    posA1s = A1s > 0;
    if any(A1s)
        [~,maxLLRatioIdx] = max(currLLRBasket{i}.*posA1s);
        A1est           = A1s(maxLLRatioIdx);
        B1est           = currB1sBasket{i}(maxLLRatioIdx);
        B0est           = currB0sBasket{i}(maxLLRatioIdx);
        XYZest          = cellfun(@(x) x(maxLLRatioIdx),currDomainBasket{i});
        theta0          = num2cell([XYZest' gaussSigmas A1est B1est]);
        % iterative MLE
        spotParams{i}   = MLEbyIteration(currData,theta0,currReadNoise,currDomains,params);
    end
     incrementParForProgress();
end
toc
spotParams = removeEmptyCells(spotParams);
% curate away those spots that did not converg
badConvergence = cellfun(@(x) isempty(x.logLike),spotParams);
spotParams(badConvergence) = [];
% convert to struct array
spotParams = cell2mat(spotParams);



