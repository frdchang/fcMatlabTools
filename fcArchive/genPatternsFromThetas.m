function [genLambda,genDLambda,genD2Lambda] = genPatternsFromThetas(domains,thetas,maxThetas,k)
%GENPATTERNSFROMTHETAS will generate the patterns summed specified by
%thetas = {{patternObj,theta},{patternObj,theta},...,{[B]}}
% theta = [A, thetaForPatternObj]
% 
% genLambda = k*(A1*Pattern1(theta1) + A2*Pattern2(theta2) + ... + B)
% genDLambda = {D wrt k, D wrt A1, [D wrt theta1], D wrt A2, ... D wrt B}
% genD2Lambda is the cross of genDLambda

genLambda = 0;
genDLambda = cell(numel(thetas),1);
genD2Lambda = cell(numel(thetas),1);
for eachPattern = 1:numel(thetas)
    currPatternObj = thetas{eachPattern}{1};
    if isobject(currPatternObj)
        % it is a pattern object so do pattern object construction
        currTheta      = thetas{eachPattern}{2:end};
        currMaxTheta   = maxThetas{eachPattern};
        [currLambda,currDLambda,currD2Lambda] = currPatternObj.givenThetaGetDerivatives(currTheta,domains,currMaxTheta);
        genLambda = genLambda + currLambda;
        genDLambda{eachPattern} = currDLambda;
        genD2Lambda{eachPattern} = currD2Lambda;
    elseif isscalar(currPatternObj)
        
    else
        error('theta is neither an object or a scalar');
    end
end




