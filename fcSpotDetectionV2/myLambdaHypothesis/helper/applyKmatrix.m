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
            appliedK{ii} = appliedK{ii} + littleLambdas{ii}*Kmatrix(ii,jj);
        end
    end
else
    if size(littleLambdas{1},2) == 1
        % if littleLambdas is compsoed of a linear cell array its D
        for ii = 1:numDatas
            for jj = 1:numDatas
               
            end
        end
    elseif size(littleLambdas{1},2) == size(littleLambdas{1},1)
        % if littleLambdas is composed of a matrix of cell arrays its D2
        display('D2');
    else
        error('littleLambdas is a weird cell array type');
    end
end




