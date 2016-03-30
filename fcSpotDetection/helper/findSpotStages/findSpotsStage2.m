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
plot3Dstack(BWmask);
% feather accepted peaks
BWmask = imdilate(BWmask,strel('arbitrary',ones(params.featherSize)));
plot3Dstack(BWmask);
stats = regionprops(BWmask,'PixelIdxList','PixelList');

candidates.peaks = peaks;
candidates.stats = stats;


% %% fulfill minimum criteria for kernSize
% % find centroids of each connected region and put a kernSize region there
% 
% %% fulfill minimum criteria for skeleton
% % remove small regions that are bigger than kernSize in a given dimension
% % then dilate from there
% 
% %% do the union of the above operations
% 
% 
% 
% 
% 
% 
% % expand the volumes by feathersize.  
% featherSizeStrel = strel('arbitrary',ones(params.featherSize));
% BWmask = imdilate(BWmask,featherSizeStrel);
% 
% % find kernel size regions
% kernSizeStrel = strel('arbitrary',ones(params.kernSize));
% BWmask = imopen(BWmask,kernSizeStrel);
% 
% 
% peaks = peaks.*BWmask;

% 
% % find maximum values in each candidates as the initial position, amp and
% % background then launch findSpotsStage3 on them



