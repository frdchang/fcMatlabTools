function psfData = threshPSF(psfData,thresh)
%THRESHPSF returns the bounded volume defined by the threshold upon the
%   PSF.

psfData = getSubsetwBBoxND(psfData,selectCenterBWObj(psfData > thresh));


end

