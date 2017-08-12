function [ overlayed ] = overlayTracks( fluorViews,spotTracks )
%OVER Summary of this function goes here
%   Detailed explanation goes here

numTimePoints = size(fluorViews,2);
overlayed = fluorViews;
for ii = 1:numTimePoints
    if ~isempty(spotTracks{ii})
            currViews = fluorViews(:,ii);
            maxZ = maxintensityproj(spotTracks{ii},3);       
            maxX = maxintensityproj(spotTracks{ii},1);
            maxY= maxintensityproj(spotTracks{ii},2);
            overlayed{1,ii} = indexedOverlay(fluorViews{1,ii},maxZ);
            overlayed{2,ii} = indexedOverlay(fluorViews{2,ii},maxY);
            overlayed{3,ii} = indexedOverlay(fluorViews{3,ii},maxX');
    end
end

