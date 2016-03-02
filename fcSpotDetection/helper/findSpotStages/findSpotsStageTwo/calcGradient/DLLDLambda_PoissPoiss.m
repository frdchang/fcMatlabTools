function DLLDLambda = DLLDLambda_PoissPoiss(d,lambda,sigmasq)
%DLLDLAMBDA_POISSPOISS Summary of this function goes here
%   Detailed explanation goes here

DLLDLambda = (d - lambda) ./ (bsxfun(@plus,lambda,sigmasq));
end

