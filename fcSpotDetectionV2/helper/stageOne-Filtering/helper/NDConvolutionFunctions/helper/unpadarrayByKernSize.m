function [ unpadded ] = unpadarrayByKernSize(data,padSize )
%UNPADARRAYBYKERNSIZE will unpad by kernSize



numDims = numel(padSize);
dataSize = size(data);
idx = cell(numDims,1);
for i = 1:numDims
    idx{i} = padSize(i)+1:dataSize(i)-padSize(i);
end
unpadded = data(idx{:});
end

