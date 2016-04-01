function spotParamStruct = findSpotsStage3(data,givenStat,numSpotsToFit,varargin)
%FINDSPOTSSTAGETHREE Summary of this function goes here
% 
% arg1:     arg1 is this
% arg2:     arg2 is that
% 
% [notes] - a heads up for the user
% 
% [param cascade] -> MLEbyIteration

%--parameters--------------------------------------------------------------
params.stepSize     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


state = MLEbyIteration(data,theta0,readNoise,domains,type,params{:});
