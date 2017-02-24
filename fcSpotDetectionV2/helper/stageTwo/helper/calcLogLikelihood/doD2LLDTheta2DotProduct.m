function D2LLD2Thetas = doD2LLDTheta2DotProduct(DLLDLambdas,D2LLDLambdas2,bigDLambdas,D2LambdaD2Thetas,newtonRaphsonSelctorD1,hessianSelectorD)
%DOD2LLDTHETA2DOTPRODUCT Summary of this function goes here
%   Detailed explanation goes here

numDatas = numel(DLLDLambdas);
D2LLD2Thetas = cell(numDatas,1);

for ii = 1:numDatas
   D2LLD2Thetas{ii} = zeros(size(hessianSelectorD)); 
   currError = DLLDLambdas{ii}(:);
   currD2Error = D2LLDLambdas2{ii}(:);
   % second part of chain rule
   D2LLD2Thetas{ii}(hessianSelectorD) = cellfun(@(x) sum(x(:).*currError),D2LambdaD2Thetas{ii}(hessianSelectorD));
   % first part of chain rule
   temp = {bigDLambdas{ii,newtonRaphsonSelctorD1}};
   numSelect = sum(newtonRaphsonSelctorD1);
   tempFirstPart = zeros(numSelect,numSelect);
   for jj = 1:numSelect
       for kk = 1:numSelect
           tempFirstPart(jj,kk) = sum(currD2Error.*temp{jj}(:).*temp{kk}(:));
       end
   end
   D2LLD2Thetas{ii}(hessianSelectorD) =  D2LLD2Thetas{ii}(hessianSelectorD) + tempFirstPart(:);
   D2LLD2Thetas{ii} = D2LLD2Thetas{ii}(any(hessianSelectorD,2),any(hessianSelectorD,1));
end


