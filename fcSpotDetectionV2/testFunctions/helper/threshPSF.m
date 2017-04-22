function [psfData,thresh] = threshPSF(psfData,thresh)
%THRESHPSF returns the bounded volume defined by the threshold upon the
%   PSF.  if thresh is a vector then it is a BBox size centered at the
%   brightest pixel


if isempty(thresh)
   [thresh, ~, ~] = threshold(multithresh(psfData(:)), max(psfData(:)), maxintensityproj(psfData,3)); 
end

if isscalar(thresh)
    psfData = getSubsetwBBoxND(psfData,selectCenterBWObj(psfData > thresh));
else
    brightestCoor = findCoorWithMax(psfData);
    [psfData,thresh] = getSubsetwCentroidANdBBoxSizeND(psfData,cell2mat(brightestCoor),thresh);
end




