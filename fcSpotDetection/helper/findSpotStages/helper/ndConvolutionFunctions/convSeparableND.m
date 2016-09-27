function dataTempConv = convSeparableND(data,separatedTemplate)
%CONVSEPARABLEFFTND executes separable convolution given that the template
%is in {templateX,templateY,templateZ,...} with each template oriented in
%the correct dimension.
% 
% fchang@fas.harvard.edu

sizeData=size(data);
numDims=length(sizeData);
dataTempConv = data;
for i = 1:numDims
    dataTempConv = convn(separatedTemplate{i},dataTempConv);
end


end

