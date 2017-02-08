function [estimated] = findSpotsStage1V2(data,spotKern,cameraVariance,varargin)
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
% detected.A0:      MLE of A1 of a spot with no backgroung
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
%         - if there is multi spectral datasets, then each dataset is in a
%           cell array.  in this condition varargin must be the bleedthru
%           matrix K.
%
% fchang@fas.harvard.edu

persistent spotKernSaved;
persistent cameraVarianceSaved;
persistent invVar;
persistent k1;
persistent k3;
persistent k5;
persistent Normalization;

warning('spotKern is assumed symmetric so far');

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
    Normalization = k1.^2 - k5.*k3;
    spotKernSaved = spotKern;
    cameraVarianceSaved = cameraVariance;
end


if ~iscell(data)
    % data is just a numeric array
    dataNormed = data.*invVar;
    k2 = convFunc(dataNormed,spotKern);
    k4 = convFunc(dataNormed,onesSizeSpotKern);
    k6 = convFunc(dataNormed.*data,onesSizeSpotKern);
    % parameters given A*spotKern + B, model of 1 spot
    A0          = k2./ k3;
    A1          = (k1.*k4 - k5.*k2 ) ./ Normalization;
    B1          = (k1.*k2 - k3.*k4)  ./ Normalization;
    LL1         = -((B1.^2).*k5 + A1.*(2*B1.*k1 - 2*k2 + A1.*k3) - 2*B1.*k4 + k6);
    % parmeters given B only, model of 0 spot
    B0          = k4./k5;
    LL0         = -((B0.^2).*k5 - 2*B0.*k4 + k6);
    
    A0         = unpadarray(A0,size(data));
    A1         = unpadarray(A1,size(data));
    B1         = unpadarray(B1,size(data));
    B0         = unpadarray(B0,size(data));
    LLRatio    = unpadarray(LL1-LL0,size(data));
else
    dataNormed      = cellfunNonUniformOutput(@(x) x.*invVar,data);
    k2              = cellfunNonUniformOutput(@(x) convFunc(x,spotKern),dataNormed);
    k4              = cellfunNonUniformOutput(@(x) convFunc(x,onesSizeSpotKern),dataNormed);
    dataNormeddata  = cellfunNonUniformOutput(@(x,y) x.*y,dataNormed,data);
    k6              = cellfunNonUniformOutput(@(x) convFunc(x,onesSizeSpotKern),dataNormeddata);
    A0              = cellfunNonUniformOutput(@(x) x./k3,k2);
    A1              = cellfunNonUniformOutput(@(x,y) (k1.*x - k5.*y ) ./ Normalization,k4,k2);
    B1              = cellfunNonUniformOutput(@(x,y) (k1.*x - k3.*y)  ./ Normalization,k2,k4);
    LL1             = cellfunNonUniformOutput(@(B1,A1,k2,k4,k6) -((B1.^2).*k5 + A1.*(2*B1.*k1 - 2*k2 + A1.*k3) - 2*B1.*k4 + k6),B1,A1,k2,k4,k6);
    B0              = cellfunNonUniformOutput(@(k4) k4./k5,k4);
    LL0             = cellfunNonUniformOutput(@(B0,k4,k6) -((B0.^2).*k5 - 2*B0.*k4 + k6),B0,k4,k6);
    
    A0              = cellfunNonUniformOutput(@(A0,data) unpadarray(A0,size(data)),A0,data);
    A1              = cellfunNonUniformOutput(@(A1,data) unpadarray(A1,size(data)),A1,data);
    B1              = cellfunNonUniformOutput(@(B1,data) unpadarray(B1,size(data)),B1,data);
    B0              = cellfunNonUniformOutput(@(B0,data) unpadarray(B0,size(data)),B0,data);
    LLRatio         = cellfunNonUniformOutput(@(LL1,LL0,data) unpadarray(LL1-LL0,size(data)),LL1,LL0,data);
    
    if ~isempty(varargin)
       Kmatrix = varargin{1};
       invKmatrix = inv(Kmatrix);
       A0 = applyInvKmatrix(invKmatrix,A0);
       A1 = applyInvKmatrix(invKmatrix,A1);
       B1 = applyInvKmatrix(invKmatrix,B1);
       B0 = applyInvKmatrix(invKmatrix,B0);
       LLRatio = applyInvKmatrix(invKmatrix,LLRatio);
    end
end


estimated.A0         = A0;
estimated.A1         = A1;
estimated.B1         = B1;
estimated.B0         = B0;
estimated.LLRatio    = LLRatio;

estimated.spotKern   = spotKern;

% historical note: previous version of my code outputed A as Abefore noted
% below, which is incorrect.
% Abefore = (k2-k1.*k4./k5)./sqrt(k3./k5 - (k1./k5).^2);



end

