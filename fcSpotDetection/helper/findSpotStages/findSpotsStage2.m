function candidates = findSpotsStage2(detected,varargin)
%FINDSPOTSSTAGE2 find candidate regions among the processed output of the
% data from findSpotsStage1. 
% 
% detected:     output struct from findSpotsStage1
% candidates:   output data structure organized as...
% 
% [notes] - this function does h-dome 
% 
% [param cascade] -> subFunc1
%                 -> subFunc2

%--parameters--------------------------------------------------------------
params.LLRatioLocalPeak  = 15;
params.minVol            = 20;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

peaks = hdome(detected.LLRatio,params.LLRatioLocalPeak,6);

BWmask = bwareaopen(peaks>0, params.minVol,6);
peaks = peaks.*BWmask;

end

