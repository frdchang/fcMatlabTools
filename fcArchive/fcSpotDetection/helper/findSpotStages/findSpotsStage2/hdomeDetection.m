function candidates = hdomeDetection(detected,varargin)
%HEDOMEDETECTION find candidate regions among the processed output of 
% the data from findSpotsStage1 by h-dome transformation the Log Likelihood 
% Ratio 
% 
% detected:     output struct from findSpotsStage1
% candidates:   output data structure organized as ...

%--parameters--------------------------------------------------------------
% set hdome height
params.height            = 25;
% set min acceptable volume 
params.minVol            = 15;
% feather volumes by
params.featherSize       = [2 2 2];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

peaks = imhmin(detected.LLRatio,params.height,6)-params.height;
BWmask = (peaks > 0.001).*(detected.A1>0);
BWmask = bwareaopen(BWmask,params.minVol,6);
% BWmask = imdilate(BWmask,strel('arbitrary',ones(params.featherSize)));
% segment and output
stats = regionprops(BWmask,'PixelIdxList','PixelList');

candidates.peaks    = peaks;
candidates.BWmask   = BWmask;
candidates.stats    = stats;


