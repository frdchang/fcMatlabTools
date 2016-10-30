function [spotParams,estimated,candidates] = fcSpotDetection(data,varargin)
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
% convert to electrons?
params.convert2Electrons       = false;
params.gain                    = 2.1;
params.offset                  = 1;
params.QE                      = 10;
% spotInfo
params.spotData                = [];
params.lambdaModel             = @lambda_single3DGauss;
params.constThetaVals          = [0.9,0.9,0.9];
params.constThetaSet           = [0 0 0 1 1 1 0 0];
% read noise data
params.readNoiseVar            = [];
%--------------------------------------------------------------------------

%-pre-calculations---------------------------------------------------------
% if spot data is not provided, check if user is using
% @lambda_single3Dgauss and use the parameters from it to generate a spot
% kernel
if isempty(params.spotData) && isequal(params.lambdaModel,@lambda_single3DGauss)
    threshold = 0.00015;
    myKernel = genSpotDataFromLambda_single3Dgauss(params.constThetaVals(1),params.constThetaVals(3),threshold);
    % in the future check if a gaussian
    [~,myGaussKernel] = ndGauss(params.constThetaVals,size(myKernel));
    myGaussKernel = cellfunNonUniformOutput(@(x) x./max(x(:)),myGaussKernel);
    params.spotData = myGaussKernel;
%     params.spotData = myKernel;
else
    error('params.spotData is not empty, or it is but you are not using lambda_single3Dgauss');
end

% generate uniform readNoise if it is not the same size as your data
if ~isequal(size(params.readNoiseVar),size(data))
   params.readNoiseVar = ones(size(data)); 
end
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% convert to electrons?
if params.convert2Electrons
   [electronData,photonData] = returnElectrons(data,params.gain,params.offset,params.QE); 
end

% stage 1 do fourier MLE
estimated = findSpotsStage1(data,params.spotData,params.readNoiseVar);
% stage 2 select subset
candidates = findSpotsStage2(estimated,params.spotData,params);
% stage 3 iterative
spotParams = findSpotsStage3(data,params.constThetaVals,params.readNoiseVar,estimated,candidates,params);

end


