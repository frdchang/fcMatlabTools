function [listOfCandidates] = selectCandidatesFuse(listOfEstimated,varargin)
%SELECTCANDIDATESFUSE given a selected candidate, will select the next
%candidate based on a radius criteria

%--parameters--------------------------------------------------------------
params.rSearch      = 5;  % how far away to highlight search
params.doParallel   = false;
params.neighborTs   = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


if iscell(listOfEstimated{1})
    estimated = load(listOfEstimated{1}{1});
    numTimePoints = numel(listOfEstimated{1});
else
    estimated = listOfEstimated{1};
    numTimePoints = numel(listOfEstimated);
end
estimated = estimated.estimated;

if iscell(estimated.A1)
    if iscell(estimated.spotKern{1})
        sizeKern = cellfun(@(x) numel(x),estimated.spotKern{1});
    else
        sizeKern = size(estimated.spotKern{1});
    end
else
    sizeKern = size(estimated.spotKern);
end
candidates = cell(numTimePoints,1);

[sorted,idxsorted]=sort_nat(listOfEstimated{1});


disp('applying select candidates to all the timepoints');
if params.doParallel
    setupParForProgress(numTimePoints);
    parfor ii = 1:numTimePoints
        incrementParForProgress();
        if iscell(listOfEstimated{1})
            estimated = load(listOfEstimated{1}{ii});
            estimated = estimated.estimated;
            useMask   = importStack(listOfEstimated{2}{ii});
            candidates{ii} = selectCandidates(estimated,varargin{:},'useMask',useMask);
        else
            estimated = load(listOfEstimated{1}{ii});
            estimated = estimated.estimated;
            candidates{ii} = selectCandidates(estimated,varargin{:});
        end
    end
    candidates = candidates(idxsorted);
    listOfCandidates = cell(numTimePoints,1);
    disp(['linking select candidates with neighbors ' num2str(params.neighborTs)]);
    setupParForProgress(numTimePoints);
    
    searchDisc = strel('sphere',params.rSearch);
    for ii = 1:numTimePoints
        incrementParForProgress();
        flankingTimePoints = ii-params.neighborTs : ii + params.neighborTs;
        flankingTimePoints(flankingTimePoints < 1) = [];
        flankingTimePoints(flankingTimePoints > numTimePoints) = [];
        flankingTimePoints(flankingTimePoints == ii) = [];
        searchVolumes = 0;
        for jj = 1:numel(flankingTimePoints)
            searchVolumes = searchVolumes + imdilate(candidates{flankingTimePoints(jj)}.seeds,searchDisc);
        end
        % find maximum values in each search volume
        neighborSeeds = findMaxInRegions(candidates{ii}.smoothField,searchVolumes);
        neighborSeeds = neighborSeeds + candidates{ii}.seeds;
        
        minBBoxMask = imdilate(neighborSeeds>0,strel(ones(sizeKern(:)')));
        L = candidates{ii}.L > 0 | minBBoxMask;
        
        [L,~,seeds] = breakApartMasks(candidates{ii}.smoothField,L>0);
        L = bwareaopen(L,candidates{jj}.params.minVol);
        L = bwlabeln(L>0);
        stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
        listOfCandidates{ii}.L = L;
        listOfCandidates{ii}.stats= stats;
        listOfCandidates{ii}.seeds = seeds;
    end
    
else
    
end
setupParForProgress(numTimePoints);
for ii = 1:numTimePoints
    incrementParForProgress();
    if iscell(listOfEstimated{1})
        estimated = load(listOfEstimated{1}{ii});
        estimated = estimated.estimated;
        useMask   = importStack(listOfEstimated{2}{ii});
        candidates{ii} = selectCandidates(estimated,varargin{:},'useMask',useMask);
    else
        estimated = load(listOfEstimated{1}{ii});
        estimated = estimated.estimated;
        candidates{ii} = selectCandidates(estimated,varargin{:});
    end
end
candidates = candidates(idxsorted);
listOfCandidates = cell(numTimePoints,1);
disp(['linking select candidates with neighbors ' num2str(params.neighborTs)]);
setupParForProgress(numTimePoints);

searchDisc = strel('sphere',params.rSearch);
for ii = 1:numTimePoints
    incrementParForProgress();
    flankingTimePoints = ii-params.neighborTs : ii + params.neighborTs;
    flankingTimePoints(flankingTimePoints < 1) = [];
    flankingTimePoints(flankingTimePoints > numTimePoints) = [];
    flankingTimePoints(flankingTimePoints == ii) = [];
    searchVolumes = 0;
    for jj = 1:numel(flankingTimePoints)
        searchVolumes = searchVolumes + imdilate(candidates{flankingTimePoints(jj)}.seeds,searchDisc);
    end
    % find maximum values in each search volume
    neighborSeeds = findMaxInRegions(candidates{ii}.smoothField,searchVolumes);
    neighborSeeds = neighborSeeds + candidates{ii}.seeds;
    
    minBBoxMask = imdilate(neighborSeeds>0,strel(ones(sizeKern(:)')));
    L = candidates{ii}.L > 0 | minBBoxMask;
    
    [L,~,seeds] = breakApartMasks(candidates{ii}.smoothField,L>0);
    L = bwareaopen(L,candidates{jj}.params.minVol);
    L = bwlabeln(L>0);
    stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
    currcandidates.L        = L;
    currcandidates.stats    = stats;
    currcandidates.seeds    = seeds;
    listOfCandidates{ii} = currcandidates;
end

