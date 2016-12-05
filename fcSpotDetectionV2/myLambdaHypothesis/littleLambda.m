function [littleLambda,littleDLambda,littleD2Lambda] = littleLambda(domains,thetaInputs,maxThetasInputs,varargin)
%LITTLELAMBDA outputs a summation of multiple patterns with their
%corresponding thetas, and then background.  this function will calculate
%the derivatves if the user requests them by capturing the outputs.
%maxThetas tell this function which derivtives to take
%
% littleLambda = k(A1*pattern1(theta1) + A2*pattern2(theta2) + ... + B)
%
% e.g.
%
% thetaInputs = {k,{patternObj1,theta1},{patternObj2,theta2},B}
% maxThetas = {1,[1 1 1 1],[1 1 1 1 0 0 0],1}
%
% with myPatternObj instantiated from myPattern
%
% if no derivatives are needed, then maxThetas can be empty
%
% math notes 12/2/2016 (picture of math in freds photos)

numPatterns = numel(thetaInputs);
numDerivatives = recursivesum(maxThetasInputs);

littleDLambda = cell(numDerivatives,1);
littleD2Lambda = cell(numDerivatives,numDerivatives);
littleLambda = 0;
littleD2Lambda(:) = {0};

k = thetaInputs{1};

gradientIndex = 3;
hessianIndex = 3;
switch nargout
    case {0 1}
        
    case {2}
        
    case {3}
        for ii = 2:numPatterns
            if isobject(thetaInputs{ii}{1})
                % it is a pattern obj
                currPattern = thetaInputs{ii};
                currPatternObj = currPattern{1};
                currPatternTheta = currPattern{2};
                currAmp = currPatternTheta(1);
                currTheta = currPatternTheta(2:end);
                currMaxTheta = maxThetasInputs{ii};
                patternMaxTheta = currMaxTheta(2:end);
                numMaxTheta = sum(patternMaxTheta);
                [currLambdas,currDLambdas,currD2Lambdas] = currPatternObj.givenThetaGetDerivatives(domains,currTheta,patternMaxTheta,varargin{:});
                % update little lambda
                littleLambda = littleLambda + currAmp*currLambdas;
                % append gradient of little lambda
                littleDLambda(gradientIndex-1) = {k*currLambdas};
                littleDLambda(gradientIndex:gradientIndex+numMaxTheta-1) = cellfunNonUniformOutput(@(x) k*x,currDLambdas);
                gradientIndex = gradientIndex+numMaxTheta+1;
                % append hessian of little lambda
                littleD2Lambda(hessianIndex:hessianIndex+numMaxTheta-1,hessianIndex:hessianIndex+numMaxTheta-1) = cellfunNonUniformOutput(@(x) k*x,currD2Lambdas);
                % append gradients flanks to hessian
                littleD2Lambda(hessianIndex-1,hessianIndex:hessianIndex+numMaxTheta-1) =  cellfunNonUniformOutput(@(x) k*x,currDLambdas);
                littleD2Lambda(hessianIndex:hessianIndex+numMaxTheta-1,hessianIndex-1) =  cellfunNonUniformOutput(@(x) k*x,currDLambdas);
                % append gradients for dk
                littleD2Lambda(1,hessianIndex:hessianIndex+numMaxTheta-1) =  cellfunNonUniformOutput(@(x) currAmp*x,currDLambdas);
                littleD2Lambda(hessianIndex:hessianIndex+numMaxTheta-1,1) =  cellfunNonUniformOutput(@(x) currAmp*x,currDLambdas);
                % append shape 
                littleD2Lambda(1,hessianIndex-1) = {currLambdas};
                littleD2Lambda(hessianIndex-1,1) = {currLambdas};
                hessianIndex = hessianIndex+numMaxTheta+1;
            elseif isscalar(thetaInputs{ii}{1})
                % is is the background scalar
                B = thetaInputs{ii}{1};
                littleLambda = littleLambda + B;
                littleDLambda(gradientIndex-1) = {k};
                gradientIndex = gradientIndex + 1;
                littleD2Lambda(hessianIndex,1) = {1};
                littleD2Lambda(1,hessianIndex) = {1};
                hessianIndex = hessianIndex+1;
            else
                error('thetaInputs need to be composed of a scalar background or pattern object with its theta inputs');
            end
        end
        
    otherwise
        error('number of outputs exceed what this function does');
end

littleDLambda{1} = littleLambda;
littleLambda = k*littleLambda;
% filter the output by maxthetas
