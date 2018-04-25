function [ overlayed ] = overlayTracks(fluorViews,spotTracks,saveNumTracks,spotViews)
%OVER varargin can pass spot data

numTimePoints = size(fluorViews,2);
overlayed = normCellArraytoUINT8(fluorViews);

if isempty(spotTracks)
    return;
end

for ii = 1:numTimePoints
    if ~isempty(spotTracks{ii})
        maxZ = maxintensityproj(spotTracks{ii},3);
        maxX = maxintensityproj(spotTracks{ii},1);
        maxY = maxintensityproj(spotTracks{ii},2);
        % generate spots
        spots_1 = indexedOverlay(overlayed{1,ii},spotViews{1,ii},[1 1 0]);
        spots_2 = indexedOverlay(overlayed{2,ii},spotViews{2,ii},[1 1 0]);
        spots_3 = indexedOverlay(overlayed{3,ii},spotViews{3,ii},[1 1 0]);
        % generate tracks
        overlayed{1,ii} = indexedOverlay(spots_1,maxZ, saveNumTracks);
        overlayed{2,ii} = indexedOverlay(spots_2,maxY, saveNumTracks);
        overlayed{3,ii} = indexedOverlay(spots_3,maxX',saveNumTracks);
    end
end



