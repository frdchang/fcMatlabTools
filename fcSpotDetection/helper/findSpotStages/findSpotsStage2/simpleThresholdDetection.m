function candidates = simpleThresholdDetection(detected,varargin)
%SIMPLETHRESHOLDDETECTION Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.LLRatioThresh     = 50;
% use otsu to threshold LLRatio
params.minVol            = 10;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% threshold by the value selected above
% only select areas with A1 > 0

peaks = detected.LLRatio.*(detected.LLRatio>params.LLRatioThresh).*(detected.A1>0);
BWmask = peaks>0;

% find non-zero peaks with a minum volume of pixels.  this number is the
% autocorrelation size and depends on the SNR
BWmask = bwareaopen(BWmask, params.minVol,6);

% segment and output
stats = regionprops(BWmask,'PixelIdxList','PixelList');
candidates.peaks    = peaks;
candidates.BWmask   = BWmask;
candidates.stats    = stats;
end

