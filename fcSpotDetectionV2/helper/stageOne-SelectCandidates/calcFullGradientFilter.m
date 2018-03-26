function [ fullGrads ] = calcFullGradientFilter(data,estimated,kern,kernDs,cameraVariance )
%CALCFULLGRADIENTFILTER 

convFunc            = @convFFTND;
kern                = flipAllDimensions(kern);
kernDs              = cellfunNonUniformOutput(@(x) flipAllDimensions(x),kernDs);
sqSpotKern          = kern.^2;
onesSizeSpotKern    = genSeparableOnes(size(kern));

currInvVar          = 1./cameraVariance;
dataNormed          = data.*currInvVar;

k1equiv     = cellfunNonUniformOutput(@(x) convFunc(currInvVar,x),kernDs);
k3equiv     = cellfunNonUniformOutput(@(x) convFunc(currInvVar,kern.*x),kernDs);
k2equiv     = cellfunNonUniformOutput(@(x) convFunc(dataNormed,x),kernDs);

gradientsXYZ   = cellfunNonUniformOutput(@(k1equiv,k2equiv,k3equiv) -estimated.A1.*estimated.B1.*k1equiv + estimated.A1.*k2equiv - (estimated.A1.^2).*k3equiv,k1equiv,k2equiv,k3equiv);

clear('k1equiv','k3equiv','k2equiv');

k1          = convFunc(currInvVar,kern);
k3          = convFunc(currInvVar,sqSpotKern);
k5          = convSeparableND(currInvVar,onesSizeSpotKern);
k2          = convFunc(dataNormed,kern);
k4          = convSeparableND(dataNormed,onesSizeSpotKern);

gradientOfA     = -estimated.B1.*k1 -estimated.A1.*k3 + k2;
gradientOfB     = -estimated.B1.*k5 -estimated.A1.*k1 + k4;

fullGrads = {gradientOfA, gradientOfB,gradientsXYZ{:}};

