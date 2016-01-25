function datatempCC = xcorrFFTND(data,template)
%CONVFFTND executes FFT convolution
% convFFTND(T,I) zero pads Totsize = size(data) + size(template) - 1
% note: tested against matlab xcorr2
% fchang@fas.harvard.edu

sizeTemplate = size(template);
sizeData = size(data);
numDims = ndims(template);
% do convolution on data and flippedTemplate, the cross correlation
flippedTemplate = template;
for i = 1:numDims
   flippedTemplate = flip(flippedTemplate,i); 
end

Totsize = sizeData + sizeTemplate-1;
fftData = fftn(data,Totsize);
fftTemplate = fftn(flippedTemplate,Totsize);
datatempCC = real(ifftn(fftData.* fftTemplate));

end
