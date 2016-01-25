function [dataTemplateConv] = convOverLapAddFFTND(data,template,Nblocks)
%OVERLAPADDCONVFFTND applys n-dimensional FFT convolution of data with
%template, but the transform is done using overlap-add method with the
%dataset divided into Nblocks.  ndim(data) = ndim(template) = ndim(Nblocks)
% this function assumes numel(data) > numel(template), so it chunks upon
% data
% notes: 
%for vector chunking use Nblocks [chunks,1] notation, not just [chunks],e.g
% overLapAddConvFFTND(ones(10000,1),ones(100,1),[10,1]); to chunk the
% vector in 10.  
% 
%for datasize [1024,1024,21] with template size [10,10,10]
% Nblocks = [25,25,1] gives an optimal speedup
%for datasize [512,512,21] with template size [10,10,10]
% Nblocks = [9,9,1] gives an optimal speedup
%
% fchang@fas.harvard.edu
sizeData = size(data);
sizeTemplate = size(template);
numChunks = prod(Nblocks);
% initialize output with zero-padding to accomodate template size
dataTemplateConv = zeros(sizeData + sizeTemplate - 1);
chunkSubs = chunkSubOfDataND(sizeData,Nblocks);
for i = 1:numChunks
    % grab a chunk of data, indexed by i
    chunkSub = chunkSubs{i};
    convChunk = convFFTNDTemplateCache(data(chunkSub{:}),template);
    % save chunk in corresponding output, with the starting coordinates of
    % chunkSub0 : size(dataChunk) + sizeTemplate - 1
    sizeChunk = size(convChunk);
    sizeChunkCell = num2cell(sizeChunk');
    outputSub = cellfun(@(x,y) x(1):x(1)+y-1,chunkSub,sizeChunkCell,'UniformOutput',false);
    dataTemplateConv(outputSub{:}) =  dataTemplateConv(outputSub{:}) + convChunk;
end

end

function datatempConv = convFFTNDTemplateCache(data,template)
%CONVFFTND executes FFT convolution
% convFFTND(T,I) zero pads Totsize = size(data) + size(template) - 1
% note: tested against matlab's conv2 function
% note: extended this method to cache the template FFT but change the
% templateFFT when a different size data unit comes in
% fchang@fas.harvard.edu

persistent templateCache;
persistent fftTemplate;
persistent oldDataSize;
sizeData = size(data);

if ~isequal(template,templateCache) || ~isequal(oldDataSize,sizeData)
    templateCache = template;
    sizeTemplate = size(templateCache);
    Totsize = sizeData + sizeTemplate-1;
    fftTemplate = fftn(template,Totsize);
    oldDataSize = sizeData;
else
    sizeTemplate = size(templateCache);
    Totsize = sizeData + sizeTemplate-1;
end


fftData = fftn(data,Totsize);
datatempConv = real(ifftn(fftData.* fftTemplate));

end

 