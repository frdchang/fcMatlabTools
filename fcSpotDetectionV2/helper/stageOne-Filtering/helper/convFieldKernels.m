function [theDotProduct] = convFieldKernels(fields,fieldKernels)
%CONVCONVERINGKERNEL will do the dot product between the convergingKernel
%and the gradients

[fieldKernels,emptyOnes] = removeEmptyCells(fieldKernels);
fields(emptyOnes) = [];
fieldKernels = cellfunNonUniformOutput(@(x) flipAllDimensions(x),fieldKernels);
theDotProduct = cellfunNonUniformOutput(@(currGrad,currKern) normxcorr3FFT(currKern,currGrad),fields,fieldKernels);
% theDotProduct = cellfunNonUniformOutput(@(x,fields) unpadarray(x,size(fields)),theDotProduct,fields);
theDotProduct = sumCellContents(theDotProduct);

end

