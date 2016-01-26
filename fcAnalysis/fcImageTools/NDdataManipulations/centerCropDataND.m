function B = centerCropDataND(A,Bsize)
% centerCropDataND crops ndimensional A to Bsize, centered
%
% fchang@fas.harvard.edu

Bstart=ceil((size(A)-Bsize)/2)+1;
Bend=Bstart+Bsize-1;
numDims = ndims(Bsize);
idx = cell(numDims,1);
for i = 1:numDims
    idx{i} = Bstart(i):Bend(i);
end
B = A(idx{:});