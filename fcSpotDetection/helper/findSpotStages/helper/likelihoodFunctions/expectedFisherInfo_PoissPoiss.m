function fisherInfoMatrix = expectedFisherInfo_PoissPoiss(lambdaFunc,theta,domains,maxThetas)
%EXPECTEDFISHERINFO_POISSPOISS returns the fisher information matrix of a
% poisson distributed data. 
%
% lambdaFunc:       the lambda function
% theta:            theta parameter set for lambdaFunc
% domains:          the {x,y,z,...} domains for lambdaFunc
% maxThetas:        the set that selects which theta to return the fisher
%                   information of

getDLambdaDThetas = lambdaFunc(theta,domains,maxThetas,1);

end

