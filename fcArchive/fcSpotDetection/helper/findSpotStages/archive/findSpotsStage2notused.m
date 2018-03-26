function candidates = findSpotsStage2(detected,varargin)
%FINDSPOTSSTAGE2 find candidate regions among the processed output of the
% data from findSpotsStage1 by thresholding the Log Likelihood Ratio and
% feathering that output.  
% 
% detected:     output struct from findSpotsStage1
% candidates:   output data structure organized as ...
%
% [notes] - this function output candidates as connected components that
%           does not have to be rectangular bounding boxes.  this
%           accomodates the fitting of spots to complex shapes.


%--parameters--------------------------------------------------------------
% 1: auto threshold
% 2: otsu
% 3: manually
params.selectBy         = 1;
% auto threshold by calculating the LLRatio where A1 is negative
params.percentOfNegA1   = 0.99;
% set threshold manually
params.LLRatio           = 50;
% use otsu to threshold LLRatio
params.otsuLevels        = 2;
% parameters for generic thresholding
params.minVol            = 15;
params.featherSize       = [2 2 2];
params.plotSteps         = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

switch params.selectBy
    case 1
        % auto threshold by using negative values of A1 as the estimate
        % background noise and thresholding that
        negA1Idx = detected.A1<0;
        [N,edges] = histcounts(detected.LLRatio(negA1Idx));
        interpEdges = edges(2):0.1:edges(end);
        interpCum = interp1(edges(2:end),cumsum(N/sum(N)),interpEdges,'linear');
        closestIdx = discretize(params.percentOfNegA1,interpCum);
        LLRatioThreshold = interpEdges(closestIdx);
        % 
    case 2
        % use otsu to separate out signal and background of the LLRatio
        LLRatioThreshold = multithresh(detected.LLRatio(:),params.otsuLevels);
        LLRatioThreshold = LLRatioThreshold(1);
    case 3
        % manual threshold
        LLRatioThreshold = params.LLRatio;
    otherwise
        error('selectBy is not 1,2 or 3');
end

% threshold by the value selected above
% only select areas with A1 > 0

peaks = detected.LLRatio.*(detected.LLRatio>LLRatioThreshold).*(detected.A1>0);
BWmask = peaks>0;
if params.plotSteps
    plot3Dstack(BWmask,'text','BWmask');
end

% find non-zero peaks with a minum volume of pixels.  this number is the
% autocorrelation size and depends on the SNR
BWmask = bwareaopen(BWmask, params.minVol,6);

if params.plotSteps
    plot3Dstack(BWmask,'text','BWmask selected for minVol');
end

% feather accepted peaks
BWmask = imdilate(BWmask,strel('arbitrary',ones(params.featherSize)));

if params.plotSteps
    plot3Dstack(BWmask,'text','BWmask feathered');
end

% segment and outpu
stats = regionprops(BWmask,'PixelIdxList','PixelList');
candidates.peaks    = peaks;
candidates.BWmask   = BWmask;
candidates.stats    = stats;



