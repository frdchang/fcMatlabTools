function D2LLD2Thetas = doD2LLDTheta2DotProduct(DLLDLambdas,D2LambdaD2Thetas,hessianSelectorD)
%DOD2LLDTHETA2DOTPRODUCT Summary of this function goes here
%   Detailed explanation goes here

numDatas = numel(DLLDLambdas);
D2LLD2Thetas = cell(numDatas,1);

for ii = 1:numDatas
   D2LLD2Thetas{ii} = zeros(size(hessianSelectorD)); 
   currError = DLLDLambdas{ii}(:);
   D2LLD2Thetas{ii}(hessianSelectorD) = cellfun(@(x) sum(x(:).*currError),D2LambdaD2Thetas{ii}(hessianSelectorD));
   D2LLD2Thetas{ii} = D2LLD2Thetas{ii}(any(hessianSelectorD,2),any(hessianSelectorD,1));
end


