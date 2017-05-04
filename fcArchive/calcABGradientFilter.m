function gradientAB = calcABGradientFilter(data,estimated,kern,cameraVariance)
%CALCABGRADIENTFILTER will calculate the gradients of A and B

convFunc            = @convFFTND;
kern                = flipAllDimensions(kern);
sqSpotKern          = kern.^2;
onesSizeSpotKern    = genSeparableOnes(size(kern));
% k1,k2,k3,k4,k5
currInvVar  = 1./cameraVariance;
k1          = convFunc(currInvVar,kern);
k3          = convFunc(currInvVar,sqSpotKern);
k5          = convSeparableND(currInvVar,onesSizeSpotKern);
dataNormed  = data.*currInvVar;
k2          = convFunc(dataNormed,kern);
k4          = convSeparableND(dataNormed,onesSizeSpotKern);

gradientOfA     = -estimated.B1.*k1 -estimated.A1.*k3 + k2;
gradientOfB     = -estimated.B1.*k5 -estimated.A1.*k1 + k4;

gradientAB = {gradientOfA, gradientOfB};


