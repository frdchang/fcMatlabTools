function spotParams = fcSpotDetection(dataSet,spotInfo,readNoise)
%FCSPOTDETECTION will detect spots in your dataset.
% 
% dataSet:      this is your dataset
% spotInfo:     spotInfo.spotData = the numeric kernel 
%               spotInfo.lambdaModel = @lambda_single3DGauss
%               spotInfo.constTheta = [ 0.9 0.9 0.9];
%               spotInfo.constThetaSet = [0 0 0 1 1 1 0 0];
% readNoise:    this is your camera readNoise, which is the same size as
%               your dataset
%
% [notes] - i really only tested for 3D datasets
% 
% [param cascade] -> subFunc1
%                 -> subFunc2
 
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% stage 1 do fourier MLE

% stage 1 refined

% stage 2 select subset

% stage 3 iterative 


