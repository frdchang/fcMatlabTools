function [gradData,hessData] = NDgradientAndHessian(data,domains)
%NDGRADIENTANDHESSIAN returns the numerically calculated gradient or
%hessian depending on the output argument specified.

numDims = ndims(data);
gradData = cell(numDims,1);

spacingBasket = calcSpacing(domains);

[gradData{:}] = gradient(data,spacingBasket{:});

if nargout == 2
    hessData = cell(numDims,numDims);
    for ii = 1:numDims
        [hessData{:,ii}] = gradient(gradData{ii},spacingBasket{:});
    end
end

