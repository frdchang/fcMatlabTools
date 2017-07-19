function [gradData,hessData] = NDgradientAndHessian(data,domains)
%NDGRADIENTANDHESSIAN returns the numerically calculated gradient or
%hessian depending on the output argument specified.

numDims = ndims(data);
gradData = cell(numDims,1);


%spacingBasket = cellfunNonUniformOutput(@(x) -x,calcSpacing(domains));

spacingBasket = calcSpacing(domains);
for ii = 1:numel(spacingBasket)
   spacingBasket{ii} = -spacingBasket{ii}; 
end
for ii = 1:numel(domains)
   spacingBasket{ii} = -spacingBasket{ii}; 
end

[gradData{:}] = gradient(data,spacingBasket{:});
gradData = flipXYCoors(gradData);
temp = cell(numDims,1);
if nargout == 2
    hessData = cell(numDims,numDims);
    for ii = 1:numDims
        
        [temp{:}] = gradient(gradData{ii},spacingBasket{:});
        temp = flipXYCoors(temp);
        [hessData{:,ii}] = temp{:};
    end
end

