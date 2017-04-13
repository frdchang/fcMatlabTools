function [binned] = NDbinData(data,patchSize)
%BINDATA will take data and sum blocks by patchSize.  so dims of patchSize
%must equal data and each dimension of patchSize needs to be a divisor of
%each dimension of data.
% 
% code has been checked by the following:
% A = rand(10,10,10,10)*100;
% A = round(A)
% out = binData(A,[5,5,5,5]);
% test = convn(A,ones(5,5,5,5));
% test = test(5:5:end,5:5:end,5:5:end,5:5:end);
% isequal(test,out)  9/23/16 -fc

numDims = ndims(data);
if ~isequal(numDims,numel(patchSize))
    binned = data;
    return;
end
outputSize = size(data)./patchSize;
if isequal(outputSize,size(data))
    binned = data;
    return;
end
if ~isequal(round(outputSize),outputSize)
    error('patchSize is not a clean multiple of the dimensions of data');
end

temp = sum(reshape(data,patchSize(1),[]),1);
for i = 2:numDims   
    temp = sum(reshape(temp,prod(outputSize(1:i-1)),patchSize(i),[]),2);
end
binned = reshape(temp,outputSize);

