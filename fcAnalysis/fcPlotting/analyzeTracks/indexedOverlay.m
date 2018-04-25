function [ rgbOverlay ] = indexedOverlay(data,indexedOverlay,varargin)
%INDEXEDOVERLAY if the varargin is a triplet matrix it will use that color
%to overlay

if isempty(varargin)
    indices = unique(indexedOverlay);
    indices(indices < 1) = [];
else
    indices = 1:varargin{1};
end

if ~isempty(varargin) && numel(varargin{1}) == 3
    myMap = varargin{1};
else
    myMap = distinguishable_colors(numel(indices),[0 0 0]);
end

validColorImage = (ndims(data) == 3) && (size(data,3) == 3);
if ~(ismatrix(data) || validColorImage)
    rgbOverlay = norm2RGB255(data);
else 
    rgbOverlay = data; 
end


for ii = 1:numel(indices)
    currMap = indexedOverlay==ii;
    rgbOverlay = imoverlay(rgbOverlay,currMap,myMap(ii,:));
end


end

