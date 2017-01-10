function [bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs,maxThetasInputs,varargin)
%BIGLAMBDA generates the lambda hypothesis for multi-spectral datasets with
%spectral bleed thru modeled by the Kmatrix = bleedthru matrix.   
%
% thetaInputs = {Kmatrix,sthetaInputForChannel1,thetaInputForChannel2,...}
% with thetaInputForChannel1 e.g. = {{patternObj1,theta1},{patternObj2,theta2},B}
% 
% maxThetasInputs are similar
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
    if isempty(varargin)
        [littleLambdas{ii},littleDLambdas{ii},littleD2Lambdas{ii}] = littleLambda(domains,thetaInputs{ii},maxThetasInputs{ii});
    else
        [littleLambdas{ii},littleDLambdas{ii},littleD2Lambdas{ii}] = littleLambda(domains,thetaInputs{ii},maxThetasInputs{ii},varargin{:});
    end
end

bigLambdas   = applyKmatrix(Kmatrix,littleLambdas);
bigDLambdas  = applyKmatrix(Kmatrix,littleDLambdas);
bigD2Lambdas = applyKmatrix(Kmatrix,littleD2Lambdas,littleDLambdas);


%% curate the derivatives by maxThetasInput

% curate the Kmatrix derivatives

% curate the rest
for ii = 1:numDatas
    
end
end

