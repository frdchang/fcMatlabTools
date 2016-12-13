function [bigLambda,bigDLambda,bigD2Lambda] = bigLambda(Kmatrix,domains,thetaInputs,maxThetasInputs,varargin)
%BIGLAMBDA generates the lambda hypothesis for multi-spectral datasets with
%spectral bleed thru modeled by the Kmatrix = bleedthru matrix.  the
%diagonal entries are 1. 

% thetaInputs = {Kmatrix,{patternObj1,theta1},{patternObj2,theta2},B}


numDatas = size(Kmatrix,2);

[littleLambda,littleDLambda,littleD2Lambda] = littleLambda(domains,thetaInputs,maxThetasInputs,varargin{:});

bigLambda   = cell(numDatas,1);
bigDLambda  = cell(numDatas,1);
bigD2Lambda = cell(numDatas,1);

[bigLambda{:}] = applyKmatrix(Kmatrix,littleLambda);
[bigDLambda{:}] = applyKmatrix(Kmatrix,littleDLambda);
[bigD2Lambda{:}] = applyKmatrix(Kmatrix,littleD2Lambda,maxThetasInputs);

end

