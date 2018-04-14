function [ Ibackground,maxVals ] = plotTrackStuff( trackStuff,numSeq,validTimePoints,varargin)
%PLOTTRACKSTUFF Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.upRezVert        = 1;
params.upRezHorz        = 1;
params.trackStuffAlpha  = 0.75;
params.maxVals          = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if isempty(trackStuff)
   Ibackground = [];
   return;
end
upRezVert   = params.upRezVert;
upRezHorz   = params.upRezHorz;
numSeq      = upRezHorz*numSeq;
alpha       = params.trackStuffAlpha;
numStuff    = numel(trackStuff);
if isempty(params.maxVals)
maxVals     = max(cellfun(@(x) max(x.d(:)),trackStuff));
else
   maxVals = params.maxVals; 
end
myMap       = distinguishable_colors(numStuff,[0 0 0]);

Ibackground = zeros(round(upRezVert*maxVals),numSeq,3);
options.LineWidth = 1;
for ii = 1:numStuff
     options.Color = [myMap(ii,:) alpha];
     Ibackground=bitmapplot(upRezVert*trackStuff{ii}.d,find(ismember(validTimePoints,trackStuff{ii}.t))*upRezHorz,Ibackground,options);
end
Ibackground = flipud(Ibackground);
Ibackground = vertcat(Ibackground,ones(1,size(Ibackground,2),3));
Ibackground = norm2UINT255(Ibackground);
end

