function [ overlayed ] = overlayTracks( fluorViews,spotTracks,saveNumTracks)
%OVER Summary of this function goes here
%   Detailed explanation goes here

numTimePoints = size(fluorViews,2);
overlayed = fluorViews;
if isempty(spotTracks)
   return; 
end
for ii = 1:numTimePoints
    if ~isempty(spotTracks{ii})
            currViews = fluorViews(:,ii);
            maxZ = maxintensityproj(spotTracks{ii},3);       
            maxX = maxintensityproj(spotTracks{ii},1);
            maxY = maxintensityproj(spotTracks{ii},2);
            overlayed{1,ii} = indexedOverlay(fluorViews{1,ii},maxZ,saveNumTracks);
            overlayed{2,ii} = indexedOverlay(fluorViews{2,ii},maxY,saveNumTracks);
            overlayed{3,ii} = indexedOverlay(fluorViews{3,ii},maxX',saveNumTracks);
    end
end



