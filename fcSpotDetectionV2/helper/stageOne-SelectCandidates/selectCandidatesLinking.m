function [ listOfCandidates ] = selectCandidatesLinking(listOfEstimated,varargin)
%SELECTCANDIDATESLINKING does what selectCandidates does, but links
%neighbor timepoints.
%--parameters--------------------------------------------------------------
params.neighborTs   = 1;  % how many timepoints it links
params.doParallel   = false;
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

if ~params.doParallel
    disp('applying select candidates to all the timepoints');
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
    for ii = 1:numTimePoints
        incrementParForProgress();
        currTimePoints = ii-params.neighborTs : ii + params.neighborTs;
        currTimePoints(currTimePoints < 1) = [];
        currTimePoints(currTimePoints > numTimePoints) = [];
        masterSeed = 0;
        for jj = 1:numel(currTimePoints)
            masterSeed = masterSeed + candidates{currTimePoints(jj)}.seeds;
        end
        
        minBBoxMask = imdilate(masterSeed>0,strel(ones(sizeKern(:)')));
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
else
    disp('applying select candidates to all the timepoints');
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
    parfor ii = 1:numTimePoints
        incrementParForProgress();
        currTimePoints = ii-params.neighborTs : ii + params.neighborTs;
        currTimePoints(currTimePoints < 1) = [];
        currTimePoints(currTimePoints > numTimePoints) = [];
        masterSeed = 0;
        for jj = 1:numel(currTimePoints)
            masterSeed = masterSeed + candidates{currTimePoints(jj)}.seeds;
        end
        
        minBBoxMask = imdilate(masterSeed>0,strel(ones(sizeKern(:)')));
        L = candidates{ii}.L > 0 | minBBoxMask;
        
        [L,~,seeds] = breakApartMasks(candidates{ii}.smoothField,L>0);
        L = bwareaopen(L,candidates{jj}.params.minVol);
        L = bwlabeln(L>0);
        stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
        
        listOfCandidates{ii} = candidates{ii};
        listOfCandidates{ii}.L = L;
        listOfCandidates{ii}.stats= stats;
        listOfCandidates{ii}.seeds = seeds;
    end
end
undoSort(idxsorted) = 1:numel(idxsorted);
listOfCandidates = listOfCandidates(undoSort);


