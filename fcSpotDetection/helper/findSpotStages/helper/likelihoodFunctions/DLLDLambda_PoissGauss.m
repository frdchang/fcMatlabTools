function DLLDLambda = DLLDLambda_PoissGauss( input_args )
%DLLDLAMBDA_POISSGAUSS this returns DLL/DLambda given Poisson*Gaussian
% 
% data:     dataset
% lambda:   theoretical values for the dataset
% sigmasq:  variance of the noise per pixel
% order:    derivative order (can be 1 or 2)
% 
% [notes] - does binary singleton expansion on sigmasq to dataset


switch order
    case 1
        DLLDLambda = (data - lambda) ./ (bsxfun(@plus,lambda,sigmasq));
    case 2
        DLLDLambda = -(data + sigmasq) ./ (bsxfun(@plus,lambda,sigmasq)).^2;
    otherwise
        error('derivative order needs to be 1 or 2');
end
