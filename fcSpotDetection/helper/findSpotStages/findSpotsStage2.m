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
params.LLRatioLocalPeak  = 15;
params.minVol            = 15;
params.featherSize       = [3 3 3];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% threshold LLratio
peaks = detected.LLRatio.*(detected.LLRatio>params.LLRatioLocalPeak);

% find non-zero peaks with a minum volume of pixels.  this number is the
% autocorrelation size and depends on the SNR
BWmask = bwareaopen(peaks>0, params.minVol,6);


% feather accepted peaks
BWmask = imdilate(BWmask,strel('arbitrary',ones(params.featherSize)));


stats = regionprops(BWmask,'PixelIdxList','PixelList');

candidates.peaks = peaks;
candidates.stats = stats;



