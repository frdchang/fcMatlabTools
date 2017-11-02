function [psfData,thresh] = threshPSF(psfData,thresh)
%THRESHPSF returns the bounded volume defined by the threshold upon the
%   PSF.  if thresh is a vector then it is a BBox size centered at the
%   brightest pixel

if iscell(psfData)
    if isscalar(thresh)
        psfData = cellfunNonUniformOutput(@(x) getSubsetwBBoxND(x,selectCenterBWObj(psfData > thresh)),psfData);
    else
        for ii = 1:numel(psfData)
           currMax = find(psfData{ii}(:)==max(psfData{ii}(:)));
           psfData{ii} = psfData{ii}([1:thresh(ii)] + floor(currMax) - floor((thresh(ii))/2)-1);
        end
    end
    return;
end

if isempty(thresh)
    [thresh, ~, ~] = threshold(multithresh(psfData(:)), max(psfData(:)), maxintensityproj(psfData,3));
end

if isscalar(thresh)
    psfData = getSubsetwBBoxND(psfData,selectCenterBWObj(psfData > thresh));
else
    brightestCoor = findCoorWithMax(psfData);
    [psfData,thresh] = getSubsetwCentroidANdBBoxSizeND(psfData,cell2mat(brightestCoor),thresh);
end
psfData(psfData == -inf) = 0;




