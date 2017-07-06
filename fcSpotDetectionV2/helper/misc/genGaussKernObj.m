function [ psfObj ] = genGaussKernObj(sigmaSQ,patchSize,varargin)
%GENGAUSSKERNOBJ Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.binning     = 3;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

binning = params.binning;
sigmas = sqrt(sigmaSQ);
kernBinning = ndGauss((sigmas*binning).^2,patchSize*binning);
psfObj = myPattern_Numeric(kernBinning,'downSample',[binning,binning,binning]);

end

