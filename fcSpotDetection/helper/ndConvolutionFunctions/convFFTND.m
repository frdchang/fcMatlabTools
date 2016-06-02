function datatempConv = convFFTND(data,template)
%CONVFFTND executes FFT convolution
% convFFTND(T,I) zero pads Totsize = size(data) + size(template) - 1
% note: -tested against matlab's conv2 function
%       -added feature in which template dimension does not have to be
%        equal to data dimension.  this function will simply apply the
%        template convultion to the dimensions that are left over
% fchang@fas.harvard.edu


sizeTemplate = size(template);
sizeData = size(data);

if ndims(data) == ndims(template)
    % if dimension of template is equal to data simply execute the FFT
    Totsize = sizeData + sizeTemplate-1;
    fftData = fftn(data,Totsize);
    fftTemplate = fftn(template,Totsize);
    datatempConv = real(ifftn(fftData.* fftTemplate));
else
    % if dimension of template is not equal to data, find the dimension
    % with one element in the template, then index this dimension for the
    % data
    error('not finished yet');
    idxMissingDim = ones(1,numel(sizeData));
    checkFor1Elements = sizeTemplate == 1;
    idxMissingDim(1:numel(checkFor1Elements)) = checkFor1Elements;
    idxMissingDim = idxMissingDim.*sizeData;
    idxMissingDim(~checkFor1Elements) = 1;
    idxMissingDim = mat2cell(idxMissingDim,1,ones(1,numel(idxMissingDim)));
    idx = cellfun(@(x) ones(1,x),idxMissingDim,'UniformOutput',false);
    chunks = mat2cell(data,idx{:});
end

end


