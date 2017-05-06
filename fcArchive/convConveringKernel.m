function [theDotProduct] = convConveringKernel(fields,fieldKernels)
%CONVCONVERINGKERNEL will do the dot product between the convergingKernel
%and the gradients

[fieldKernels,emptyOnes] = removeEmptyCells(fieldKernels);
fields(emptyOnes) = [];
fieldKernels = cellfunNonUniformOutput(@(x) flipAllDimensions(x),fieldKernels);
theDotProduct = cellfunNonUniformOutput(@(currGrad,currKern) convFFTND(currGrad,currKern),fields,fieldKernels);
theDotProduct = sumCellContents(theDotProduct);

end

