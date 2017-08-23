function [ infoMatrix,asymtotVar,stdErrorMatrix] = calcExpectedFisherInfo(bigLambdas,bigDLambdas,camVarInLambdaUnits)
%CALCFISHERINFO given thetas, this function calculates the expected fisher
%information and the symtotic variance = inv(fisher);
% standard error = sqrt of diagonal of the variance matrix
%
% the expected fisher info is calculated by = E[dLLDthetai * dLLDthetaj]
% 
% firstpart = 1/(lambda + noise)
% secondpart = dLambdaDthetai * dLambdaDthetaj
% 

firstPart = cellfunNonUniformOutput(@(bigLambdas) 1./(bigLambdas + camVarInLambdaUnits),bigLambdas);
secondPart = cellfunNonUniformOutput(@(bigDLambdas) cellOuterProduct(bigDLambdas),bigDLambdas);

infoMatrix = cellfun(@(firstPart,secondPart) firstPart.*secondPart,firstPart,secondPart);
infoMatrix = cellfun(@(infoMatrix) sum(infoMatrix(:)),infoMatrix);

asymtotVar = inv(infoMatrix);
stdErrorMatrix = sqrt(asymtotVar);


