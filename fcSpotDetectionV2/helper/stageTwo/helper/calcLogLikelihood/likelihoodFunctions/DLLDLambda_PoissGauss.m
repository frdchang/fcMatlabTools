function DLLDLambda = DLLDLambda_PoissGauss(data,lambda,sigmasq,order)
%DLLDLAMBDA_POISSGAUSS this returns DLL/DLambda given Poisson*Gaussian
% 
% data:     dataset
% lambda:   theoretical values for the dataset
% sigmasq:  variance of the noise per pixel
% order:    derivative order (can be 1 or 2)


sigma = sqrt(sigmasq);
switch order
    case 1
        DLLDLambda = calcDPoissGaussDLambda(data,lambda,sigma)./calcPoissGauss(data,lambda,sigma);
    case 2
        f = calcPoissGauss(data,lambda,sigma);
        d1 = calcDPoissGaussDLambda(data,lambda,sigma);
        d2 = calcD2PoissGaussDLambda2(data,lambda,sigma);
        DLLDLambda = (-d1.^2 + f.*d2)./(f.^2);
    otherwise
        error('derivative order needs to be 1 or 2');
end

DLLDLambda(isnan(DLLDLambda)) = 0;
