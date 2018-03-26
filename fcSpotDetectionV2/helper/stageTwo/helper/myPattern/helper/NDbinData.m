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

% if no binning, patchSize is a ones vector or isempty just return data
if all(patchSize==1) || isempty(patchSize)
   binned = data;
   return;
end

% if data is a vector, pathSize needs to have 1 binning for the 1 dimension
% to make it match in size

if isvector(data)
   temp = ones(1,numel(size(data)));
   temp(size(data)~=1) = patchSize;
   patchSize = temp;
end

% otherwise make sure data is integer increments of patchSize.  if not pad
% by zeros at the end

increments = size(data)./patchSize;

% if increments not integer, pad by zeros
if ~isequal(round(increments),increments)
    data = padarray(data, round((ceil(increments)-increments).*patchSize),0,'post');
end
outputSize = size(data)./patchSize;

temp = sum(reshape(data,patchSize(1),[]),1)/patchSize(1);
for i = 2:ndims(data)   
    temp = sum(reshape(temp,prod(outputSize(1:i-1)),patchSize(i),[]),2)/patchSize(i);
end
binned = reshape(temp,outputSize);

