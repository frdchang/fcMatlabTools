function [ peakImg ] = phaseCorrelation( data,template,gaussianFilterSigma)
%PHASECORRELATION 

sizeData = size(data);

dataFT = fftn(data,sizeData);
templateFT = conj(fftn(template,sizeData));
gaussianFilter = abs(fftn(ndGauss([1.5,1.5,1.5],[6 6 6]),sizeData));

H = gaussianFilter./(abs(dataFT).*abs(templateFT));
 peakImg = ifftshift(ifftn(dataFT.* templateFT.*H));





