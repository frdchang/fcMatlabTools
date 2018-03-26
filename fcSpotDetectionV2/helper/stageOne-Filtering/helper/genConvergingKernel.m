function [convergingKernel] = genConvergingKernel(kernel)
%GENCONVERGINGKERNEL will generate a converging kernel in which the
%gradient vectors are pointing to the center of the kernel.
sizeOfKernel = size(kernel);


crossKern = convFFTND(padarray(kernel,size(kernel),'replicate'),kernel);
crossKern = unpadarray(crossKern,size(kernel));


numDims = numel(sizeOfKernel);
centerCoor = getCenterCoor(sizeOfKernel);
convergingKernel = cell(numDims,1);
for ii = 1:numDims
   convergingKernel{ii} = zeros(sizeOfKernel); 
end
domains = genMeshFromData(ones(sizeOfKernel));

for ii = 1:numDims
   convergingKernel{ii} =  centerCoor(ii) - domains{ii}; 
end

myNorm = sqrt(sumCellContents(cellfunNonUniformOutput(@(x) x.^2,convergingKernel)));
convergingKernel = cellfunNonUniformOutput(@(x) x./myNorm.*crossKern,convergingKernel);

centerCoor = num2cell(centerCoor);
for ii = 1:numDims 
   convergingKernel{ii}(centerCoor{:}) = 0; 
end