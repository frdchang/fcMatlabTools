function candidates = findSpotsStage2(detected,varargin)
%FINDSPOTSSTAGE2 Summary of this function goes here
% 
% detected:     output struct from findSpotsStage1
% 
% [notes] - a heads up for the user
% 
% [param cascade] -> subFunc1
%                 -> subFunc2

%--parameters--------------------------------------------------------------
params.LLratioLocalPeak  = 15;
params.minVol            = 20;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

BWmask = bwareaopen(BWmask, minVolume,6);

end

