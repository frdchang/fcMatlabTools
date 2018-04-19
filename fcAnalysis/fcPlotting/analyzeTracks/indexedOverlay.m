function [ rgbOverlay ] = indexedOverlay(data,indexedOverlay,varargin)
%INDEXEDOVERLAY Summary of this function goes here
%   Detailed explanation goes here
if isempty(varargin)
indices = unique(indexedOverlay);
indices(indices < 1) = [];
else
indices = 1:varargin{1};
end
myMap = distinguishable_colors(numel(indices),[0 0 0]);

rgbOverlay = norm2RGB255(data);
for ii = 1:numel(indices)
   currMap = indexedOverlay==ii;
   rgbOverlay = imoverlay(rgbOverlay,currMap,myMap(ii,:));
end


end

