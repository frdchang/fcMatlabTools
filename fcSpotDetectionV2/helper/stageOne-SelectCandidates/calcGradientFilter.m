function [ gradientsXYZ ] = calcGradientFilter(data,estimated,kern,kernDs,cameraVariance)
%CALCGRADIENTMAG will calculate the gradients of the approximate
%log Likelihood.  derivation is in designGradientAndHessianFilters.nb

convFunc    = @convFFTND;
kern        = flipAllDimensions(kern);
kernDs      = cellfunNonUniformOutput(@(x) flipAllDimensions(x),kernDs);

invVar      = 1./cameraVariance;
dataNormed  = data.*invVar;
k1equiv     = cellfunNonUniformOutput(@(x) convFunc(invVar,x),kernDs);
k3equiv     = cellfunNonUniformOutput(@(x) convFunc(invVar,kern.*x),kernDs);
k2equiv     = cellfunNonUniformOutput(@(x) convFunc(dataNormed,x),kernDs);

gradientsXYZ   = cellfunNonUniformOutput(@(k1equiv,k2equiv,k3equiv) -estimated.A1.*estimated.B1.*k1equiv + estimated.A1.*k2equiv - (estimated.A1.^2).*k3equiv,k1equiv,k2equiv,k3equiv);

