function [ cropped ] = cropCenterSize(ndData,sizeCrop )
%CROPCENTERSIZE crops the data to the center with sizeCrop.  if ndData is a
%cell array that represents a separable kernel, it will go through each
%dimension and crop by sizeCrop

if isempty(ndData)
   cropped = [];
   return;
end
if iscell(ndData)
    numDims = numel(ndData);
    cropped = cell(numDims,1);
    for ii = 1:numDims
       currCentroid = size(ndData{ii});
       currCentroid = round(max(currCentroid(:))/2);
       cropped{ii} = ndData{ii}(currCentroid - floor(sizeCrop(ii)/2):currCentroid - floor(sizeCrop(ii)/2) + sizeCrop(ii)-1);
    end
else
    centroid = getCenterCoor(size(ndData));
    BBox = centroidWSize2BBox(centroid,sizeCrop);
    [cropped] = getSubsetwBBoxND(ndData,BBox);
end

end

