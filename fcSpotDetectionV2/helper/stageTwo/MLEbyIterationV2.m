function state = MLEbyIterationV2(datas,theta0s,sigmasqs,domains,strategy,varargin)
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
% -> gradUpdate
% -> newtonRaphsonUpdate


%--parameters--------------------------------------------------------------
% gradient ascent parameters
params.stepSize         = .001;
params.normGrad         = true;
% newton raphson parameters
params.numStepsNR       = 100;
% plotting parameters
params.doPloteveryN     = inf;
% MLE functions
params.DLLDTheta        = @DLLDThetaV2;
params.DLLDLambda       = @DLLDLambda_PoissPoiss;
params.LogLike          = @logLike_PoissPoiss;
% save passed data and associated stuff in structure
params.saveDatas        = false;
% the big lambda function that corresponds to the theta0s
params.bigLambdaFunc    = @bigLambda;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%--define output state structure-------------------------------------------
if params.saveDatas
    state.datas         = datas;
    state.sigmasqs       = sigmasqs;
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
[bigLambdas,bigDLambdas,bigD2Lambdas] = params.bigLambdaFunc(domains,theta0s);

% the outputs are already aligned and ready to be summed.  just need to be
% curated!
% curate by params.types

numStrategies = numel(strategy);
for ii = 1:numStrategies
    currStrategy = strategy{ii}{1};
    numIterations = strategy{ii}{2};
    [selectorD,selectorD2] = thetaSelector(currStrategy);
    for jj = 1:numIterations
        DLLDLambdas = doDLLDLambda(datas,bigLambdas,sigmasqs,params.DLLDLambda);
        % do gradient update
        gradientSelectorD = selectorD{1};
        if any(gradientSelectorD)
            DLLDThetas = doDLLDThetaDotProduct(DLLDLambdas,bigDLambdas,gradientSelectorD);
            DLLDThetas = sumCellContents(DLLDThetas);
            %
            % mleTheta = mleTheta +params.stepSize*gradAtTheta;
            theta0s = gradUpdate(theta0s,DLLDThetas,params);
        end
        
        
        % do newton raphson update
        newtonRaphsonSelctorD1 = selectorD{2};
        newtonRaphsonSelctorD2 = selectorD2;
        if any(newtonRaphsonSelctorD1)
            DLLDThetasRaphson = doDLLDThetaDotProduct(DLLDLambdas,bigDLambdas,newtonRaphsonSelctorD1);
            D2LLD2ThetasRaphson = doD2LLDTheta2DotProduct(DLLDLambdas,bigD2Lambdas,newtonRaphsonSelctorD2);
            DLLDThetasRaphson = sumCellContents(DLLDThetasRaphson);
            D2LLD2ThetasRaphson = sumCellContents(D2LLD2ThetasRaphson);
            DLLDThetasRaphson = DLLDThetasRaphson(newtonRaphsonSelctorD1);
            
%             [~,posDefOfNegHess] = chol(-selectedHessian);
%             conditionNumber = rcond(selectedHessian);
%             if posDefOfNegHess > 0 || conditionNumber < 3e-16
%                 % this is a bad hessian matrix
%                 %             warning('hessian is either not posDef or rconditinon number is < eps');
%                 state.thetaMLE = 'hessian was either not posDef or condition number for inversion was poor';
%                 return;
%             else
%                 % this is a good hessian matrix
%                 try
%                     updateMLE = selectedHessian\thisGradient(updateIndices);
%                 catch
%                     %                 warning('hessian is not inverting well');
%                     state.thetaMLE = 'hessian inversion caused error';
%                     return;
%                 end
%             end
%             mleTheta(updateIndices) = mleTheta(updateIndices) - updateMLE;
            theta0s = newtonRaphsonUpdate(theta0s,newtonRaphsonSelctorD1,DLLDThetasRaphson,D2LLD2ThetasRaphson);
        end
    end
    
end


