function [detected] = findSpotsStageOne(data,spotKern,cameraVariance)
%FINDSPOTS Summary of this function goes here
%   Detailed explanation goes here

% if spotKern || cameraVariance changes, update transformation matrix

persistent spotKernSaved;
persistent cameraVarianceSaved;
persistent invVar;
persistent k1;
persistent k3;
persistent k5;

if ~isequal(spotKernSaved,spotKern) || ~isequal(cameraVarianceSaved,cameraVariance)
    invVar = 1./cameraVariance;
    k1 = convFFTND(invVar,spotKern);
    k3 = convFFTND(invVar,spotKern.^2);
    k5 = convFFTND(invVar,ones(size(spotKern)));
    spotKernSaved = spotKern;
    cameraVarianceSaved = cameraVariance;
end

dataNormed = data.*invVar;
k2 = convFFTND(dataNormed,spotKernSaved);
k4 = convFFTND(dataNormed,ones(size(spotKernSaved)));

Normalization = k1.^2 - k5.*k3;

A = (k1.*k4 - k5.*k2 ) ./ Normalization;
B = (k1.*k2 - k3.*k4)  ./ Normalization;
% Abefore = (k2-k1.*k4./k5)./sqrt(k3./k5 - (k1./k5).^2);
% Atry = (k1.*k4 - k5.*k2 ) ./ sqrt(Normalization);

detected.A = unpadarray(A,size(data));
detected.B = unpadarray(B,size(data));
% detected.Abefore = unpadarray(Abefore,size(data));
% detected.Atry= unpadarray(Atry,size(data));
end

