function candidates = findSpotsStage2(detected,varargin)
%FINDSPOTSSTAGE2 find candidate regions among the processed output of the
% data from findSpotsStage1 and applies iterative MLE, findSpotStage3, upon
% the candidates.
% 
% detected:     output struct from findSpotsStage1
% candidates:   output data structure organized as...


%--parameters--------------------------------------------------------------
params.LLRatioLocalPeak  = 15;
params.minVol            = 15;
params.kernSize          = [7 7 7];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

peaks = detected.LLRatio.*(detected.LLRatio>params.LLRatioLocalPeak);

BWmask = bwareaopen(peaks>0, params.minVol,6);
kernSizeBox = strel('arbitrary',ones(params.kernSize));

peaks = peaks.*BWmask;
stats = regionprops(BWmask,'PixelIdxList','PixelList');

candidates.peaks = peaks;
candidates.stats = stats;

% find maximum values in each candidates as the initial position, amp and
% background then launch findSpotsStage3 on them



