function [ rgbOverlay ] = indexedOverlay(data,indexedOverlay)
%INDEXEDOVERLAY Summary of this function goes here
%   Detailed explanation goes here

indices = unique(indexedOverlay);
indices(indices < 1) = [];
myMap = distinguishable_colors(numel(indices),[0 0 0]);
rgbOverlay = norm2RGB255(data);
for ii = 1:numel(indices)
   currMap = indexedOverlay==ii;
   rgbOverlay = imoverlay(rgbOverlay,currMap,myMap(ii,:));
end


end

