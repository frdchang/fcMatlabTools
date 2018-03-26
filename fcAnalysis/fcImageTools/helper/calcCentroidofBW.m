function centroidCoor = calcCentroidofBW(BWmask)
%CALCCENTROIDOFBW returns the centroid of a mask

I = find(BWmask>0);
coors = ind2subND(size(BWmask),I);
centroidCoor = mean([coors{:}]);
centroidCoor = flipXYCoors(centroidCoor);

end

