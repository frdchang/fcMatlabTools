function spotParams = fcSpotDetection(dataInElectrons,spotInfo,readNoiseVarInElectrons,varargin)
%FCSPOTDETECTION will detect spots in your dataset.
% 
% dataSetInElectrons:       this is your dataset
% spotInfo:                 spotInfo.spotData = the numeric kernel 
%                           spotInfo.lambdaModel = @lambda_single3DGauss
%                           spotInfo.constThetaVals = [0.9 0.9 0.9];
%                           spotInfo.constThetaSet = [0 0 0 1 1 1 0 0];
% readNoiseInElectrons:     this is your camera readNoise, which is the 
%                           same size as your dataset
%
% [notes] - i really only tested for 3D datasets.  
%         - this function is not yet general for any patterns yet.
%         gaussSigmas are really the constant parameters that need to be
%         passed to the pattern.  in general any pattern has constant
%         parameters that need to be passed and this will be called
%         constThetaVals.  I need to propogate this nomenclature to the
%         rest of the code.
% 
% [param cascade] -> findSpotStage2
%                 -> findSpotStage3

 
%--parameters--------------------------------------------------------------
params.doRefinedStageOne       = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% stage 1 do fourier MLE
estimated = findSpotsStage1(dataInElectrons,spotInfo.spotData,readNoiseVarInElectrons);
% stage 2 select subset
candidates = findSpotsStage2(estimated,params);
% stage 3 iterative 
spotParams = findSpotsStage3(dataInElectrons,spotInfo.constThetaVals,readNoiseVarInElectrons,estimated,candidates,params);

