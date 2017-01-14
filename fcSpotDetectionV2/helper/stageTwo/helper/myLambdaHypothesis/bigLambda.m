function [bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs,varargin)
%BIGLAMBDA generates the lambda hypothesis for multi-spectral datasets with
%spectral bleed thru modeled by the Kmatrix = bleedthru matrix.   
%
% thetaInputs = {Kmatrix,sthetaInputForChannel1,thetaInputForChannel2,...}
% with thetaInputForChannel1 e.g. = {{patternObj1,theta1},{patternObj2,theta2},B}
% 
% maxThetasInputs are dropped and instead just mirrors the thetaInputs
% 
% varargin passes directly into littleLambda
%
% Kmatrix is the bleed thru matrix, with the rows the bleed thru.  
%
% note:the gradients and hessian are independent from each channel

Kmatrix = thetaInputs{1};
thetaInputs(1) = [];
numDatas = size(Kmatrix,2);
littleLambdas = cell(numDatas,1);
littleDLambdas = cell(numDatas,1);
littleD2Lambdas = cell(numDatas,1);


% generate little lambdas for each channel
for ii = 1:numDatas
    currInput = thetaInputs{ii};
    currInput = {1,currInput{:}};
    maxThetaInputs = maxAllThetas(currInput);
    if isempty(varargin)
        [littleLambdas{ii},littleDLambdas{ii},littleD2Lambdas{ii}] = littleLambda(domains,currInput,maxThetaInputs);
    else
        [littleLambdas{ii},littleDLambdas{ii},littleD2Lambdas{ii}] = littleLambda(domains,currInput,maxThetaInputs,varargin{:});
    end
end

bigLambdas   = applyKmatrix(Kmatrix,littleLambdas);
bigDLambdas  = applyKmatrix(Kmatrix,littleDLambdas);
bigD2Lambdas = applyKmatrix(Kmatrix,littleD2Lambdas,littleDLambdas);


