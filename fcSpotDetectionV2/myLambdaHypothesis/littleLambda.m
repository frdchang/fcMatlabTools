function [littleLambda,littleDLambda,littleD2Lambda] = littleLambda(domains,thetaInputs,maxThetasInputs,varargin)
%LITTLELAMBDA outputs a summation of multiple patterns with their
%corresponding thetas, and then background.  this function will calculate
%the derivatves if the user requests them by capturing the outputs.
%maxThetas tell this function which derivtives to take
%
% littleLambda = A1*pattern1(theta1) + A2*pattern2(theta2) + ... + B
%
% e.g.
%
% thetaInputs = {{patternObj1,A1,x1,y1,z1},{patternObj2,A2,x2,y2,z2,s1,s2,s3},B}
% maxThetas = {[1 1 1 1],[1 1 1 1 0 0 0],[1]}
%
% with myPatternObj instantiated from myPattern
%
% if no derivatives are needed, then maxThetas can be empty

numPatterns = numel(thetaInputs);
littleLambda = 0;

switch nargout
    case {0 1}
        
    case {2}
        
    case {3}
        for ii = 1:numPatterns
            if isobj(thetaInputs{ii})
                % it is a pattern obj
                currPattern = thetaInputs{ii};
                currPatternObj = currPattern{1};
                currAmp = currPattern{2};
                currTheta = currPattern{3:end};
                currMaxTheta = maxThetasInputs{ii};
                [currLambdas,currDLambdas,currD2Lambdass] = currPatternObj.givenThetaGetDerivatives(domains,currTheta,currMaxTheta,varargin{:});
                littleLambda = littleLambda + currAmp*currLambdas;
            elseif isscalar(thetaInputs{ii})
                % is is the background scalar
            else
                error('thetaInputs need to be composed of a scalar background or pattern object with its theta inputs');
            end
        end
        
    otherwise
        error('number of outputs exceed what this function does');
end

