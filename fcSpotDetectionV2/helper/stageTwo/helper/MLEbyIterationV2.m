function state = MLEbyIterationV2(A1s,carvedMask,datas,theta0s,sigmasqs,domains,strategy,varargin)
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
% stopping criteria
params.gradTol          = 0.01;
params.newtonTol        = 0.00001;
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
    state.sigmasqs      = sigmasqs;
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
state.logLikePP     = [];
state.logLikePG     = [];
state.stateOfStep   = [];
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


% the outputs are already aligned and ready to be summed.  just need to be
% curated!
% curate by params.types

numStrategies = numel(strategy);
totalIter = 1;
prevError = inf*ones(2,1);
carveddatas = cellfunNonUniformOutput(@(x) x(carvedMask),datas);
carvedsigmasqs = cellfunNonUniformOutput(@(x) x(carvedMask),sigmasqs);
for ii = 1:numStrategies
    currStrategy = strategy{ii}{1};
    numIterations = strategy{ii}{2};
    [selectorD,selectorD2] = thetaSelector(currStrategy);
    for jj = 1:numIterations
        
        [bigLambdas,bigDLambdas,bigD2Lambdas] = params.bigLambdaFunc(domains,theta0s);
        [DLLDLambdas,D2LLDLambdas2] = doDLLDLambda(datas,bigLambdas,sigmasqs,params.DLLDLambda);
        % use only carved mask
        bigLambdas = cellfunNonUniformOutput(@(x) x(carvedMask),bigLambdas);
        
        LLPP = logLike_PoissPoiss(carveddatas,bigLambdas,carvedsigmasqs);
        LLPG = logLike_PoissGauss(carveddatas,bigLambdas,carvedsigmasqs);
        if mod(jj,params.doPloteveryN) == 1
            plotMLESearchV2(carvedMask,A1s,datas,theta0s,domains,totalIter,LLPP);
        end
        for kk = 1:numel(bigDLambdas)
            if ~isscalar(bigDLambdas{kk})
                bigDLambdas{kk} = bigDLambdas{kk}(carvedMask);
            end
        end
        for kk = 1:numel(bigD2Lambdas)
            for ll = 1:numel(bigD2Lambdas{kk})
                if ~isscalar(bigD2Lambdas{kk}{ll})
                    bigD2Lambdas{kk}{ll} = bigD2Lambdas{kk}{ll}(carvedMask);
                end
            end
        end
        
        DLLDLambdas = cellfunNonUniformOutput(@(x) x(carvedMask),DLLDLambdas);
        D2LLDLambdas2 = cellfunNonUniformOutput(@(x) x(carvedMask),D2LLDLambdas2);
        
        % do gradient update
        gradientSelectorD = selectorD{1};
        if any(gradientSelectorD)
            DLLDThetas = doDLLDThetaDotProduct(DLLDLambdas,bigDLambdas,gradientSelectorD);
            DLLDThetas = sumCellContents(DLLDThetas);
            newtheta0s = gradUpdate(theta0s,DLLDThetas,gradientSelectorD,params);
            newtheta0s = ensureBkndThetasPos(newtheta0s);
        end
        % if bkgnd <0 then set it to 0
        
        if any(flattenTheta0s(newtheta0s) < 0)
            display('negative theta0s');
            break;
        else
            theta0s = newtheta0s;
        end
        %         % do newton raphson update
        newtonRaphsonSelctorD1 = selectorD{2};
        newtonRaphsonSelctorD2 = selectorD2;
        %    -0.0018   -7.3817   -0.0000         0         0         0   -0.0252    0.0245
        if any(newtonRaphsonSelctorD1)
            DLLDThetasRaphson = doDLLDThetaDotProduct(DLLDLambdas,bigDLambdas,newtonRaphsonSelctorD1);
            D2LLD2ThetasRaphson = doD2LLDTheta2DotProduct(DLLDLambdas,D2LLDLambdas2,bigDLambdas,bigD2Lambdas,newtonRaphsonSelctorD1,newtonRaphsonSelctorD2);
            DLLDThetasRaphson = sumCellContents(DLLDThetasRaphson);
            D2LLD2ThetasRaphson = sumCellContents(D2LLD2ThetasRaphson);
            DLLDThetasRaphson = DLLDThetasRaphson(newtonRaphsonSelctorD1);
            [newtheta0s,stateOfStep] = newtonRaphsonUpdate(theta0s,newtonRaphsonSelctorD1,DLLDThetasRaphson,D2LLD2ThetasRaphson);
            newtheta0s = ensureBkndThetasPos(newtheta0s);
            if ~isequal(stateOfStep,'ok')
                break;
            end
        end
        
        
        
        
        totalIter = totalIter + 1;
        currError = sum(DLLDLambdas{1}(:).^2);
        changeInError = abs(prevError(1) - currError);
        display(flattenTheta0s(theta0s));
        display(['error:' num2str(currError) 'strat:' num2str(ii)]);
        
        % if error increases too much just break and save old theta0
        %         if (currError - prevError(1)) > 2.3742e+03
        %             display('large error');
        %            break;
        %         else
        %             theta0s = newtheta0s;
        %         end
        %
        % if any of the theta0s values are negative break and save old
        % theta0
        
        if any(flattenTheta0s(newtheta0s) < 0)
            display('negative theta0s');
            break;
        else
            theta0s = newtheta0s;
        end
        
        
        %         if changeInError < params.gradTol && ii == 1 || any(abs((prevError-currError))<0.0001)
        %             break;
        %         end
        %
        %
        %         if changeInError < params.newtonTol && ii == 2
        %             break;
        %         end
        
        prevError(2) = prevError(1);
        prevError(1) = currError;
        
    end
end
state.thetaMLEs = theta0s;
if exist('stateOfStep') == 1
    state.stateOfStep = stateOfStep;
else
    state.stateOfStep = 'ok';
end
state.logLikePP = LLPP;
state.logLikePG = LLPG;




