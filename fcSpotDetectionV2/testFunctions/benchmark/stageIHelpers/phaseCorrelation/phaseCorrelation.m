function [ peakImg ] = phaseCorrelation( data,template,gaussianFilterSigma)
%this function is based on the one written in easy_dhpsf detection code by the moerner lab.  
% default gaussian sigma size they used is 1.9.  

sizeData = size(data);
sizeTemplate = size(template);
if ~isequal(sizeTemplate,sizeData)
   padSize = (sizeData - sizeTemplate)/2;
   template = padarray(template,padSize,min(template(:))); 
end

dataFT = fftn(data,sizeData);
templateFT = conj(fftn(template,sizeData));
gaussianFilter = abs(fftn(ndGauss([gaussianFilterSigma,gaussianFilterSigma,gaussianFilterSigma].^2,round([gaussianFilterSigma*4 gaussianFilterSigma*4 gaussianFilterSigma*4])),sizeData));
H = gaussianFilter./(abs(dataFT).*abs(templateFT));
peakImg = ifftshift(ifftn(dataFT.* templateFT.*H));





