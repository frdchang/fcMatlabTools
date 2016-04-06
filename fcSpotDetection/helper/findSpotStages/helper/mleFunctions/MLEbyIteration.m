function state = MLEbyIteration(data,theta0,readNoise,domains,varargin)
%MLEBYGRADIENTASCENT executes MLE by gradient ascent and/or newton raphson
%
% data:         the measured data
% theta:        the initial parameters given the model lambda
% readNoise:    the variance of the read noise
% domains:      the domains of the dataset, e.g. for 3d {x,y,z}
% type:         selects gradient ascent,1 or newton-raphson,2 or
%               both,3 in the order of gradient then newton or
%
% [note] - gradient descent is very robust so go with that on the first
% run.  once your in the quadratic regime, apply newton.


%--parameters--------------------------------------------------------------
% 1 = gradient, 2 = newton raphson, 3 = both
params.type         = 3;
% gradient ascent parameters
params.stepSize     = .05;
params.numStepsGrad = 1000;
params.normGrad     = true;
% newton raphson parameters
params.numStepsNR   = 100;
% plotting parameters
params.doPloteveryN = 10;
% MLE functions
params.lambda       = @lambda_single3DGauss;
params.maxThetas    = [1 1 1 0 0 0 1 1];
params.DLLDTheta    = @DLLDTheta;
params.DLLDLambda   = @DLLDLambda_PoissPoiss;
params.LogLike      = @logLike_PoissPoiss;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% define gradient function
gradFunc = @(mytheta) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,mytheta,domains,params.maxThetas,1);
% define hessian function
hessFunc = @(mytheta) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,mytheta,domains,params.maxThetas,2);
% define log likehood function
llFunc   = @(mytheta) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,mytheta,domains,params.maxThetas,0);

mleTheta = cell2mat(theta0(:));
if params.type == 1 || params.type == 3
    % do gradient or both, with gradient going first
    for i = 0:params.numStepsGrad
        if mod(i,params.doPloteveryN) == 0
            plotMLESearch(mleTheta,data,domains,i,'gradient MLE',params.type);
        end
        gradAtTheta = gradFunc(num2cell(mleTheta));
        if params.normGrad
           gradAtTheta = gradAtTheta / norm(gradAtTheta); 
        end
        mleTheta = mleTheta +params.stepSize*gradAtTheta; 
    end
end

if params.type == 2 || params.type == 3
    % do newton raphson or both, with gradient going first
    updateIndices = params.maxThetas>0;
    for i = 0:params.numStepsNR
        if mod(i,params.doPloteveryN) == 0
            plotMLESearch(mleTheta,data,domains,i,'newton raphson MLE',params.type);
        end
        thisGradient = gradFunc(num2cell(mleTheta));
        thisHessian = hessFunc(num2cell(mleTheta));
        try
            updateMLE = thisHessian(any(thisHessian,2),any(thisHessian,1))\thisGradient(updateIndices);
        catch exception
            warning('hessian is not inverting well');
            %--define state structure--------------------------------------------------
            state.data          = data;
            state.theta0        = theta0;
            state.readNoise     = readNoise;
            state.domains       = domains;
            state.type          = params.type;
            state.thetaMLE      = [];
            state.thetaVar      = [];
            state.lambdaModel   = params.lambda;
            state.maxThetas     = params.maxThetas;
            state.gradFunc      = gradFunc;
            state.hessFunc      = hessFunc;
            state.logLike       = [];
            %--------------------------------------------------------------------------
            return;
        end
        mleTheta(updateIndices) = mleTheta(updateIndices) - updateMLE;
        
    end
end

% calculate variance of estimates from hessian
lastHessian = hessFunc(num2cell(mleTheta));
lastHessianNoZeros = lastHessian(any(lastHessian,2),any(lastHessian,1));
fischerInfo = -lastHessianNoZeros;
thetaVar    = zeros(size(lastHessian));
thetaVar(params.maxThetas'*params.maxThetas>0) = inv(fischerInfo);

% display mleTheta as a nice row and keep as cell array form since that is
% what i pass into lambda anyways.
mleTheta = num2cell(mleTheta)';
%--define state structure--------------------------------------------------
state.data          = data;
state.theta0        = theta0;
state.readNoise     = readNoise;
state.domains       = domains;
state.type          = params.type;
state.thetaMLE      = mleTheta;
state.thetaVar      = thetaVar;
state.lambdaModel   = params.lambda;
state.maxThetas     = params.maxThetas;
state.gradFunc      = gradFunc;
state.hessFunc      = hessFunc;
state.logLike       = llFunc(mleTheta);
%--------------------------------------------------------------------------



