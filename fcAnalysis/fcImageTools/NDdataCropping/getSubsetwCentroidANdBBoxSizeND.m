function [subSet,BBox] = getSubsetwCentroidANdBBoxSizeND(data,centroid,BBoxSize)
%GETSUBSETWCENTROIDANDBBOXSIZEND returns the subset specified by its
%centroid dimensions and the size of the BBoxSize.


BBox = centroidWSize2BBox(centroid,BBoxSize);
subSet = getSubsetwBBoxND(data,BBox);

end

