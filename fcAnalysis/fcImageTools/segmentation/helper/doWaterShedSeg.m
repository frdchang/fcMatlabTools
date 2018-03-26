function segmented = doWaterShedSeg(img,seeds,bkgndmask)
%DOWATERSHEDSEG Summary of this function goes here
%   Detailed explanation goes here




minD = imimposemin(-img,seeds>0);
minD(~bkgndmask>0) = -inf;
waterL = watershed(minD);
waterL = waterL > 1;
cellMask = imreconstruct(seeds>0,waterL);
CC = bwconncomp(cellMask,8);
S  = regionprops(CC,img,'Centroid','BoundingBox','Area','MeanIntensity','PixelValues');
L  = labelmatrix(CC);

segmented.S = S;
segmented.L = L;

