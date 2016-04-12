function [ output_args ] = checkCramerRaoBound(statHolder,genSpotData,kernSize,readNoise,syntheticData)
%CHECKCRAMERRAOBOUND Summary of this function goes here
% MLE functions
params.lambda       = @lambda_single3DGauss;
params.maxThetas    = [1 1 1 0 0 0 1 1];
params.DLLDTheta    = @DLLDTheta;
params.DLLDLambda   = @DLLDLambda_PoissPoiss;
params.LogLike      = @logLike_PoissPoiss;

goodStats = ~findEmptyCells(statHolder);
statHolderGood = statHolder(goodStats);
totalMLEs = sum(cellfun(@(x) numel(x),statHolderGood));
sizeMLE = numel([statHolderGood{1}{1}.thetaMLE{:}]);
MLEholder = zeros(totalMLEs,sizeMLE);
VARholder = cell(totalMLEs,1);
LLholder  = zeros(totalMLEs,1);
index = 1;
for ii = 1:numel(statHolderGood)
    currStat = statHolderGood{ii};
    for jj = 1:numel(currStat)
        currMLEstat = currStat{jj};
        if ~ischar(currMLEstat.thetaMLE)
            MLEholder(index,:) = [currMLEstat.thetaMLE{:}];
            VARholder{index} = currMLEstat.thetaVar;
            LLholder(index) = currMLEstat.logLike;
            index = index+1;
        end
    end
end

MLEholder(index:end,:) = [];
VARholder(index:end) = [];
LLholder(index:end) = [];

% 
[x,y,z] = meshgrid(1:kernSize(1),1:kernSize(2),1:kernSize(3));
domains = {x,y,z};
% generate thetaMaster 
%{x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak}
thetaMaster = {genSpotData.yPixel,genSpotData.xPixel,genSpotData.zPixel,genSpotData.sigmaxy^2,genSpotData.sigmaxy^2,genSpotData.sigmaz^2,genSpotData.amp,genSpotData.bak};
% hess = lambda_single3DGauss(thetaMaster,{x,y,z},maxThetas,2)
% 
% hnmm...doesn't make sense... i can't calculate the fisher information
% because it is a function of data.
%
% well that is because fisher information is the Expected second derivative
% of the log likelihood...need to integrate it wrt the probability
% distribution.

hessFunc = @(mytheta) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,syntheticData,readNoise,mytheta,domains,params.maxThetas,2);
end