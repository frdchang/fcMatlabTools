function state = MLEbyIterationV2(datas,theta0s,readNoises,domains,strategy,varargin)
%MLEBYGRADIENTASCENT executes MLE by gradient ascent and/or newton raphson
%
% datas:        the measured data or datas in cell array
% theta0s:      the initial parameters given the model lambda
% readNoises:   the variance of the read noise
% domains:      the domains of the dataset, e.g. for 3d {x,y,z}
% maxThetas:    which thetas you want to maximize [bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs,varargin)
% strategy:     you can select which variables of thetas to be gradient and
%               which variables to be newton by indicated by 0 or 1.
%               0 -> a constant, 1->gradient, 2->newton  
%               types -> {{[0 0 0 1 1 2],N},{[0 0 0 2 2 2],N}}.
%               if types is empty gradient will be assumed for all
%               variables
%


%--parameters--------------------------------------------------------------
% gradient ascent parameters
params.stepSize         = .001;
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
params.saveDatas        = false;
% the big lambda function that corresponds to the theta0s
params.bigLambdaFunc    = @bigLambda;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

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
state.strategy      = strategy;
state.thetaMLEs     = [];
state.thetaVars     = [];
state.logLike       = [];
%--------------------------------------------------------------------------


% each derivative takes in a lambda(theta,domains,maxThetas,0);
% depends on the lambda function, which is different now.  or is it?
% so a big lambda comes in, {Kmatrix,{thetasForChannel1},{thetasForChannel2},...}
% big lambda can generate all the Ds and D2s and datas.  
% then i will curate these things.  

% curate bigLambda output for theta0s
%
% bigLambda needs to have a flat Kmatrix input, and a full maxThetas from
% the getgo.  types will curate the output of bigLambda

 [bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,theta0s);
 
 % the outputs are already aligned and ready to be summed.  just need to be
 % curated!
 % curate by params.types
 
numStrategies = numel(strategy);
for ii = 1:numStrategies
    currStrategy = strategy{ii};
    [selectorD,selectorD2] = thetaSelector(currStrategy);
    % do gradient ascent
    gradientSelector = selectorD{1};
    % do newton raphson
    selectorD{2};
    selectorD2;
end

 
 