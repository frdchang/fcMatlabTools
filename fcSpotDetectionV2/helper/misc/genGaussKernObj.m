function [ psfObj ] = genGaussKernObj(sigmaSQ,patchSize,varargin)
%GENGAUSSKERNOBJ Summary of this function goes here
%   Detailed explanation goes here


psfObj = myPattern_3DGaussianConstSigmas(sigmaSQ);
psfObj.givenTheta(genMeshFromData(ones(patchSize)),getCenterCoor(patchSize));

% %--parameters--------------------------------------------------------------
% params.binning     = 10;
% %--------------------------------------------------------------------------
% params = updateParams(params,varargin);
% 
% binning = params.binning;
% sigmas = sqrt(sigmaSQ);
% kernBinning = ndGauss((sigmas*binning).^2,patchSize*binning);
% psfObj = myPattern_Numeric(kernBinning,'downSample',[binning,binning,binning]);

end

