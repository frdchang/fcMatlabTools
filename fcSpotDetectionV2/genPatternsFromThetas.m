function genLambda = genPatternsFromThetas(domains,thetas)
%GENPATTERNSFROMTHETAS will generate the patterns summed specified by
%thetas = {{patternObj,theta},{patternObj,theta},...}

genLambda = 0;
for eachPattern = 1:numel(thetas)
    currPatternObj = thetas{eachPattern}{1};
    currTheta      = thetas{eachPattern}{2:end};
    genLambda = genLambda + currPatternObj.givenThetagetDriveative(domains,currTheta);
end


