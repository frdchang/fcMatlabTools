function [fisherInfoMatrix,CRLB] = expectedFisherInfo_PoissPoiss(lambdaFunc,theta,domains,maxThetas)
%EXPECTEDFISHERINFO_POISSPOISS returns the fisher information matrix of a
% poisson distributed data.
%
% lambdaFunc:       the lambda function
% theta:            theta parameter set for lambdaFunc
% domains:          the {x,y,z,...} domains for lambdaFunc
% maxThetas:        the set that selects which theta to return the fisher
%                   information of

% generate theoretical dataset given theta and lambdaFunc
getDLambdaDThetas = lambdaFunc(theta,domains,maxThetas,1);
getLambda         = lambdaFunc(theta,domains,maxThetas,0);


% calculate the fisherInfoMatrix from first derivatives.  
lambdas = cell(numel(maxThetas),numel(maxThetas));
lambdas(:) = {0};
% first generate diagonal and offdiagonal indices permitted by
% maxThetas
hessianIndices = maxThetas(:)*maxThetas(:)';
% diagonal indices
diagIndices = diag(diag(hessianIndices));
% populate diagonal
[diag_i,diag_j] = find(diagIndices);
for i = 1:numel(diag_i)
    lambdas{diag_i(i),diag_j(i)} = flattenThenSum((getLambda.^-1).*getDLambdaDThetas{diag_i(i)}.*getDLambdaDThetas{diag_j(i)});
end
% upper off diagonal entries
upperOffDiagIndices = triu(hessianIndices,1);
[offDiag_i,offDiag_j] = find(upperOffDiagIndices);
for i = 1:numel(offDiag_i)
    secondDeriv = flattenThenSum((getLambda.^-1).*getDLambdaDThetas{offDiag_i(i)}.*getDLambdaDThetas{offDiag_j(i)});
    lambdas{offDiag_i(i),offDiag_j(i)} = secondDeriv;
    lambdas{offDiag_j(i),offDiag_i(i)} = secondDeriv;
end
fisherInfoMatrix = cell2mat(lambdas);
selectedlambdas = fisherInfoMatrix(any(hessianIndices,2),any(hessianIndices,1));
CRLB = diag(inv(selectedlambdas));

