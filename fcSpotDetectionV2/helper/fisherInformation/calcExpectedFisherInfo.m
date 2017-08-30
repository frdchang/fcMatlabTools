function [ infoMatrix,asymtotVar,stdErrors,fullInfoMatrix] = calcExpectedFisherInfo(bigLambdas,bigDLambdas,camVarInLambdaUnits)
%CALCFISHERINFO given thetas, this function calculates the expected fisher
%information and the symtotic variance = inv(fisher);
% standard error = sqrt of diagonal of the variance matrix
%
% the expected fisher info is calculated by = E[dLLDthetai * dLLDthetaj]
% 
% firstpart = 1/(lambda + noise)
% secondpart = dLambdaDthetai * dLambdaDthetaj
% 

numChans = numel(bigLambdas);

firstPart = cellfunNonUniformOutput(@(x,y) 1./(x + y),bigLambdas(:),camVarInLambdaUnits(:));

% lop off Kmatrix part of bigDLambdas

secondPart = cell(numChans,1);
for ii = 1:numChans
   secondPart{ii} = cellOuterProduct(bigDLambdas(ii,:)); 
end

fullInfoMatrix = cell(size(secondPart));
for ii = 1:numel(secondPart)
    subInfo = zeros(size(secondPart{ii}));
    for jj = 1:numel(secondPart{ii})
        temp = smartElMulti(firstPart{ii},secondPart{ii}{jj});
        subInfo(jj) = sum(temp(:));
    end
    fullInfoMatrix{ii} = subInfo;
end

fullInfoMatrix = sumCellContents(fullInfoMatrix);
% take out the kmatrix part
infoMatrix = fullInfoMatrix(2*numChans+1:end,2*numChans+1:end);

conditionNumber = rcond(infoMatrix);
% check condition 
if  conditionNumber < 2e-16 || isnan(conditionNumber)


end
    
asymtotVar = inv(infoMatrix);
stdErrors= sqrt(diag(asymtotVar));


