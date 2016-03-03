function DLLDLambda = DLLDLambda_PoissPoiss(d,lambda,sigmasq)
%DLLDLAMBDA_POISSPOISS this returns DLL/DLambda given Poisson*Poisson
%approximation

DLLDLambda = (d - lambda) ./ (bsxfun(@plus,lambda,sigmasq));
end

