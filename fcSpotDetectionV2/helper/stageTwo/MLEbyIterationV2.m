function state = MLEbyIterationV2(datas,theta0s,readNoises,domains,maxThetas,varargin)
%MLEBYGRADIENTASCENT executes MLE by gradient ascent and/or newton raphson
%
% datas:        the measured data or datas in cell array
% theta0s:      the initial parameters given the model lambda
% readNoises:   the variance of the read noise
% domains:      the domains of the dataset, e.g. for 3d {x,y,z}
% maxThetas:    which thetas you want to maximize
% types:        you can select which variables of thetas to be gradient and
%               which variables to be newton by indicated by 0 or 1.
%               0 -> gradient, 1->newton.

%--parameters--------------------------------------------------------------
% if types is empty, then it will default to gradient
params.types            = [];
% gradient ascent parameters
params.stepSize         = .001;
params.numStepsGrad     = 1000;
params.normGrad         = true;
% newton raphson parameters
params.numStepsNR       = 100;
% plotting parameters
params.doPloteveryN     = inf;
% MLE functions
params.DLLDTheta        = @DLLDTheta;
params.DLLDLambda       = @DLLDLambda_PoissGauss;
params.LogLike          = @logLike_PoissPoiss;
% save passed data and associated stuff in structure
params.saveDatas         = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% define gradient function
gradFunc = @(mytheta) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,mytheta,domains,params.maxThetas,1);
% define hessian function
hessFunc = @(mytheta) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,mytheta,domains,params.maxThetas,2);
% define log likehood function
llFunc   = @(mytheta) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,mytheta,domains,params.maxThetas,0);

%--define output state structure-------------------------------------------
if params.saveDatas
    state.datas         = data;
    state.readNoises    = readNoises;
    state.domains       = domains;
else
    state.datas         = []; 
    state.readNoises    = [];
    state.domains       = [];
end
state.theta0s       = theta0s;
state.maxThetas     = params.maxThetas;
state.types         = params.types;
state.thetaMLEs     = [];
state.thetaVars     = [];
state.logLike       = [];
%--------------------------------------------------------------------------


% each derivative takes in a lambda(theta,domains,maxThetas,0);

