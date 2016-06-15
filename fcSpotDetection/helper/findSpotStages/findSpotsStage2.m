function candidates = findSpotsStage2(detected,spotData,varargin)
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
%         - this function filters the LLRATIO > thresh and A parameter > 0,
%           then smooths it to do hdome local maxima search.  
%         - then for those connected objects smaller than some value gives
%         
%
% [param cascade] -> simpleThresholdDetection

%--parameters--------------------------------------------------------------
params.LLRatioThresh     = 50;
params.minVol            = 3;
params.smoothingKernel   = [0.9,0.9,0.9];
params.smoothingSize     = [7 7 7];
% params.featherSize       = [3 3 3];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% smooth LLRatio
[~,sepKernel] = ndGauss(params.smoothingKernel,params.smoothingSize);
smoothLLRatio = convSeparableND(detected.LLRatio,sepKernel);
smoothLLRatio = unpadarray(smoothLLRatio,size(detected.LLRatio));
% threshold by the value selected above
% only select areas with A1 > 0
peaks = smoothLLRatio.*(detected.LLRatio>params.LLRatioThresh).*(detected.A1>0);
BWmask = peaks>0;

% find non-zero peaks with a minum volume of pixels.  this number is the
% autocorrelation size and depends on the SNR
BWmask = bwareaopen(BWmask, params.minVol,6);

% fill holes
BWmask = imfill(BWmask,'holes');

% % feather
% BWmask = imdilate(BWmask,strel('arbitrary',ones(params.featherSize)));

% segment and output
stats = regionprops(BWmask,'PixelIdxList','PixelList');
candidates.peaks    = peaks;
candidates.BWmask   = BWmask;
candidates.stats    = stats;
