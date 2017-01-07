function appliedK = applyKmatrix(Kmatrix,littleLambdas,varargin)
%APPLYKMATRIX will apply the spectral bleed thru coefficient to the little
%lambdas
%
%

numDatas = size(Kmatrix,2);
appliedK = cell(numDatas,1);
appliedK(:) = {0};
% if littleLambdas is composed of numeric its lambdas
if isnumeric(littleLambdas{1})
    for ii = 1:numDatas
        for jj = 1:numDatas
            appliedK{ii} = appliedK{ii} + littleLambdas{jj}*Kmatrix(ii,jj);
        end
    end
else
    % Kmatrix gradient and hessian index holder
    KmatrixIndex = 1:numel(Kmatrix);
    KmatrixIndex = reshape(KmatrixIndex,size(Kmatrix));
    KmatrixIndexTranspose = KmatrixIndex';
    sizeOfLambdas = cellfun(@(x) size(x,1),littleLambdas);
    numDmatrix = sum(sizeOfLambdas);
    numElements =  numDmatrix - numel(littleLambdas) + numel(Kmatrix);
    if size(littleLambdas{1},2) == 1
        % if littleLambdas is compsoed of a linear cell array its D
        % generate bigDLambda memory
        
        appliedK = cell(numDatas,numElements);
        appliedK(:) = {0};
        % populate the Kmatrix part of bigDLambda
        for ii = 1:numDatas
            appliedK(ii,KmatrixIndexTranspose(:,ii)) = cellfunNonUniformOutput(@(x) x{1} ,littleLambdas);
        end
        % don't need the first K derivative so delete it
        for kk = 1:numel(littleLambdas)
           littleLambdas{kk}(1) = []; 
        end
        % populate the rest
        for ii = 1:numDatas
            Kvals = num2cell(Kmatrix(KmatrixIndexTranspose(:,ii)));
            bigDs = cellfun(@(x,y) cellfunNonUniformOutput(@(z) x*z,y),Kvals,littleLambdas,'UniformOutput',false);
            appliedK(ii,numel(Kmatrix)+1:end) = flattenCellArray(bigDs);
        end
    elseif size(littleLambdas{1},2) == size(littleLambdas{1},1)
        % if littleLambdas is composed of a matrix of cell arrays its D2
        littleDlambdas = varargin{1};
        appliedK = cell(numDatas,1);
        for ii = 1:numDatas
           appliedK{ii} = cell(numElements,numElements);
           appliedK{ii}(:) = {0};
        end
        
        % populate Kmatrix part, which is just zeros so leave as is
        
        for ii = 1:numDatas
            currKvals = KmatrixIndexTranspose(:,ii);
            for jj = 1:numel(currKvals)
                currIndex = numel(Kmatrix)+1;
                for kk = 1:numDatas
                   numcurrD = sizeOfLambdas(kk);
                   domainSelector = currIndex:currIndex+numcurrD-2;
                   % populate flanking gradients
                   appliedK{ii}(currKvals(jj),domainSelector) = littleDlambdas{kk}(2:end);
                    appliedK{ii}(domainSelector,currKvals(jj)) = littleDlambdas{kk}(2:end);
                   % populate hessian and multiply by
                   % constant~~~~~~!!!!!!!!!!!!I STOPED HERE, 
                   appliedK{ii}(domainSelector,domainSelector) = littleLambdas{kk}(2:end,2:end);
                   currIndex = domainSelector(end)+1;
                end
            end
        end
        % popualate the flanking gradients
        
        % populate the hessians
        
    else
        error('littleLambdas is a weird cell array type');
    end
end




