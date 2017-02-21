function dataFlipped = flipAllDimensions(data)
%FLIPALLDIMENSIONS will flip all the dimensions around so convolution can
%be correlation
dataFlipped = data;
for ii = 1:ndims(data)
    dataFlipped = flipdim(dataFlipped,ii);
end

