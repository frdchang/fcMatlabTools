function [binned] = NDbinData(data,patchSize)
%BINDATA will take data and sum blocks by patchSize.  so dims of patchSize
%must equal data and each dimension of patchSize needs to be a divisor of
%each dimension of data.
% 
% code has been checked by the following:
% A = rand(10,10,10)*100;
% A = round(A)
% out = binData(A,[5,5,5]);
% test = convn(A,ones(5,5,5));
% test = test(5:5:end,5:5:end,5:5:end);
% isequal(test,out)  9/23/16 -fc

numDims = ndims(data);
if numDims == 2
   if size(data,1) == 1 || size(data,2) ==1
      numDims =1; 
   end
end

if isscalar(patchSize) && numDims ==1
    binned = sum(reshape(data,patchSize,[]),1)/patchSize;
    return;
end
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

temp = sum(reshape(data,patchSize(1),[]),1)/patchSize(1);
for i = 2:numDims   
    temp = sum(reshape(temp,prod(outputSize(1:i-1)),patchSize(i),[]),2)/patchSize(i);
end
binned = reshape(temp,outputSize);

