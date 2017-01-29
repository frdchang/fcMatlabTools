function [estimated] = findSpotsStage1(data,spotKern,cameraVariance)
%FINDSPOTSSTAGE1 will find the MLE of the parameters of two statistical
% models that correspond to 1 spot or 0 spot to every position in the
% dataset using an approximate log likelihood function that accounts for
% pixel to pixel differences in readnoise.  The derivation is located in
% the math supp. ref[] and in the mathematica notebook
% designLikelihoodFilter.nb.
% 
% data:             the dataset
% spotKern:         the shape data, e.g. psf or gaussian
% cameraVariance:   the read noise in variance.  size of this dataset needs
%                   to be the same size as the data, so extrude
%                   accordingly.
%
% model1 - one spot model  - A1*spotKern + B1
% model0 - zero spot model - B0
% 
% detected is an output structure with the estimated parameters
% detected.A1:      MLE of A1 of 1 spot model
% detected.B1:      MLE of B1 of 1 spot model
% detected.B0:      MLE of B0 of 0 spot model
% detected.LLRatio: approximate log likelihood ratio of model 1 vs model 0
%
% [notes] - this function caches results so next computation is faster.
%           clear findSpotStage1 if memory needs to be opened.
%         - if spot kern is separable and provided as a separable kernel
%           spotKern = {sep1,sep2,sep3}, then separable convolution will be
%           used.
% 
% fchang@fas.harvard.edu

persistent spotKernSaved;
persistent cameraVarianceSaved;
persistent invVar;
persistent k1;
persistent k3;
persistent k5;

if iscell(spotKern)
    % convolution is separable
    convFunc = @convSeparableND;
    sqSpotKern = cellfunNonUniformOutput(@(x) x.^2,spotKern);
    onesSizeSpotKern = genSeparableOnes(cellfun(@(x) numel(x),spotKern));
else
    % otherwise just do fft
    convFunc = @convFFTND;
    sqSpotKern = spotKern.^2;
    onesSizeSpotKern = ones(size(spotKern));
end

% if spotKern || cameraVariance changes, update transformation matrix
if ~isequal(spotKernSaved,spotKern) || ~isequal(cameraVarianceSaved,cameraVariance)
    invVar = 1./cameraVariance;
    k1 = convFunc(invVar,spotKern);
    k3 = convFunc(invVar,sqSpotKern);
    k5 = convFunc(invVar,onesSizeSpotKern);
    spotKernSaved = spotKern;
    cameraVarianceSaved = cameraVariance;
end

dataNormed = data.*invVar;
k2 = convFunc(dataNormed,spotKern);
k4 = convFunc(dataNormed,onesSizeSpotKern);
k6 = convFunc(dataNormed.*data,onesSizeSpotKern);

Normalization = k1.^2 - k5.*k3;

% parameters given A*spotKern + B, model of 1 spot
A0          = k2./ k3;
A1          = (k1.*k4 - k5.*k2 ) ./ Normalization;
B1          = (k1.*k2 - k3.*k4)  ./ Normalization;
LL1         = -((B1.^2).*k5 + A1.*(2*B1.*k1 - 2*k2 + A1.*k3) - 2*B1.*k4 + k6);
% parmeters given B only, model of 0 spot
B0          = k4./k5;
LL0         = -((B0.^2).*k5 - 2*B0.*k4 + k6);

estimated.A0         = unpadarray(A0,size(data));
estimated.A1         = unpadarray(A1,size(data));
estimated.B1         = unpadarray(B1,size(data));
estimated.B0         = unpadarray(B0,size(data));
estimated.LLRatio    = unpadarray(LL1-LL0,size(data));

% historical note: previous version of my code outputed A as Abefore noted
% below, which is incorrect.
% Abefore = (k2-k1.*k4./k5)./sqrt(k3./k5 - (k1./k5).^2);



end

