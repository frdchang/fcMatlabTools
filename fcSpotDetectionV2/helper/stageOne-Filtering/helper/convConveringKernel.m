function [theDotProduct] = convConveringKernel(gradients,convergingKernel)
%CONVCONVERINGKERNEL will do the dot product between the convergingKernel
%and the gradients

convergingKernel = cellfunNonUniformOutput(@(x) flipAllDimensions(x),convergingKernel);
theDotProduct = cellfunNonUniformOutput(@(currGrad,currKern) convFFTND(currGrad,currKern),gradients,convergingKernel);
theDotProduct = sumCellContents(theDotProduct);

end

