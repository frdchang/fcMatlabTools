function BBox = selectCenterBWObj(bwMask)
%SELECTCENTERBWOBJ returns from the bwMask the object that is most center. 

centerOfMask = size(bwMask)/2;
stats = regionprops(bwMask);

distFromCenter = bsxfun(@minus,cell2mat({stats.Centroid}'),centerOfMask);
distFromCenter = sum(distFromCenter.^2,2);
indexOfCenterObj = find(distFromCenter == min(distFromCenter),1);
BBox = stats(indexOfCenterObj).BoundingBox;
end

