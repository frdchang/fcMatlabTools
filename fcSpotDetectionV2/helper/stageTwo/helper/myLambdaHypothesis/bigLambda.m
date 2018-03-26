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
%--parameters--------------------------------------------------------------
params.doMicroscopeBleedThru     = true;
params.objKerns                  = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

Kmatrix = thetaInputs{1};
thetaInputs(1) = [];
numDatas = size(Kmatrix,2);
littleLambdas = cell(numDatas,1);
littleDLambdas = cell(numDatas,1);
littleD2Lambdas = cell(numDatas,1);

bigLambdas = cell(numel(thetaInputs),1);
[bigLambdas{:}] = deal(0);

if params.doMicroscopeBleedThru
    % this does real bleed thru where the pattern manifested depends on the
    % pattern for that channel
    firstCall = true;
    for ii = 1:numDatas
        currInput = thetaInputs{ii};
        if isempty(currInput)
            continue;
        end
        currShape = currInput{1}{1};
        currInput = {1,currInput{:}};
        maxThetaInputs = maxAllThetas(currInput);
        if isempty(varargin)
            [littleLambdas{ii},littleDLambdas{ii},littleD2Lambdas{ii}] = littleLambda(domains,currInput,maxThetaInputs);
        else
            [littleLambdas{ii},littleDLambdas{ii},littleD2Lambdas{ii}] = littleLambda(domains,currInput,maxThetaInputs,varargin{:});
        end
        % replace shape object with current shape
        for jj = 1:numDatas
            if jj ~= ii
                currInput = thetaInputs{jj};
                if isscalar(currShape)
                    currInput = replaceShapeObj(currInput,params.objKerns{ii});
                else
                    currInput = replaceShapeObj(currInput,currShape);
                end
                
                currInput = {1,currInput{:}};
                maxThetaInputs= maxAllThetas(currInput);
                if isempty(varargin)
                    [littleLambdas{jj},littleDLambdas{jj},littleD2Lambdas{jj}] = littleLambda(domains,currInput,maxThetaInputs);
                else
                    [littleLambdas{jj},littleDLambdas{jj},littleD2Lambdas{jj}] = littleLambda(domains,currInput,maxThetaInputs,varargin{:});
                end
            end
        end
        % this does regular bleed thru where the pattern just manifests in another
        % channel by the bleed thru coefficient.  
        if firstCall
            % this is for pre-allocation (i don't know the size), then the rest will be overwritten
            bigLambdas   = applyKmatrix(Kmatrix,littleLambdas);
            bigDLambdas  = applyKmatrix(Kmatrix,littleDLambdas);
            bigD2Lambdas = applyKmatrix(Kmatrix,littleD2Lambdas,littleDLambdas);
            firstCall = false;
        else
            bigLambdasTemp   = applyKmatrix(Kmatrix,littleLambdas);
            bigDLambdasTemp  = applyKmatrix(Kmatrix,littleDLambdas);
            bigD2LambdasTemp = applyKmatrix(Kmatrix,littleD2Lambdas,littleDLambdas);
            
            bigLambdas{ii} = bigLambdasTemp{ii};
            bigDLambdas(ii,:) = bigDLambdasTemp(ii,:);
            bigD2Lambdas{ii} = bigD2LambdasTemp{ii};
        end
    end
else
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
    % this does regular bleed thru where the pattern just manifests in another
    % channel by the bleed thru coefficient
    bigLambdas   = applyKmatrix(Kmatrix,littleLambdas);
    bigDLambdas  = applyKmatrix(Kmatrix,littleDLambdas);
    bigD2Lambdas = applyKmatrix(Kmatrix,littleD2Lambdas,littleDLambdas);
    
    % so little lambdas are generate for each dataset
    
end








