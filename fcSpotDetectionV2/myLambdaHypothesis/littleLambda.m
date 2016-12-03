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

numPatterns = numel(thetaInputs);
numDerivatives = sum(cell2mat(maxThetasInputs));

littleDLambda = cell(numDerivatives,1);
littleD2Lambda = cell(numDerivatives,numDerivatives);
littleLambda = 0;
littleD2Lambda(:) = {0};

k = thetaInputs{1};

gradientIndex = 2;
hessianIndex = 2;
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
                [currLambdas,currDLambdas,currD2Lambdas] = currPatternObj.givenThetaGetDerivatives(domains,currTheta,currMaxTheta,varargin{:});
                % update little lambda
                littleLambda = littleLambda + currAmp*currLambdas;
                % append gradient of little lambda
                littleDLambda(gradientIndex:gradientIndex+numel(currMaxTheta)-1) = cellfunNonUniformOutput(@(x) k*x,currDLambdas);
                % append hessian of little lambda
                
                % append gradient flanks to hessian
                
            elseif isscalar(thetaInputs{ii})
                % is is the background scalar
                B = thetaInputs{ii};
                littleLambda = littleLambda + B;
            else
                error('thetaInputs need to be composed of a scalar background or pattern object with its theta inputs');
            end
        end
        
    otherwise
        error('number of outputs exceed what this function does');
end

littleDLambda{1} = littleLambda;
littleLambda = k*littleLambda;
