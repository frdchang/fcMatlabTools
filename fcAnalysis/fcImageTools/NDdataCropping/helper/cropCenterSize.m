function [ cropped ] = cropCenterSize(ndData,sizeCrop )
%CROPCENTERSIZE Summary of this function goes here
%   Detailed explanation goes here

centroid = getCenterCoor(size(ndData));

BBox = centroidWSize2BBox(centroid,sizeCrop);

[cropped] = getSubsetwBBoxND(ndData,BBox);
end

