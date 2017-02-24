function DLLDThetas = doDLLDThetaDotProduct(DLLDLambdas,DLambdaDThetas,gradientSelectorD)
%DODLLDTHETADOTPRODUCT will apply the full chain rule dot product
% 
% note that gradientSelectorD will only calc the dot for those that are
% flagged as 1.  otherwise the gradient is zero
numDatas = numel(DLLDLambdas);
DLLDThetas = cell(numDatas,1);
for ii = 1:numDatas
    DLLDThetas{ii} = zeros(size(gradientSelectorD));
    currError = DLLDLambdas{ii}(:);
    currDLDT = DLambdaDThetas(ii,gradientSelectorD);
    DLLDThetas{ii}(gradientSelectorD) = cellfun(@(x) sum(x(:).*currError),currDLDT);
end
