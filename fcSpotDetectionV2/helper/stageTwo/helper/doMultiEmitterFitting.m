function [ states ] = doMultiEmitterFitting(carvedMask,maskedPixelId,datas,estimated,camVar,Kmatrix,objKerns,varargin)
%DOMULTIEMITTERFITTING will iteratively do multi emitter fitting
% for multi spots, it keeps doing gradient, then finishes with newton, but
% next iteration uses gradient theta0
% theta0 is provided it will use theta0

%--parameters--------------------------------------------------------------
params.numSpots     = 2;
params.gradSteps    = 200;
params.hybridSteps  = 0;
params.newtonSteps  = 0;
params.doPlotEveryN = 0;
params.theta0       = {};
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

states = cell(params.numSpots+1,1);
domains{ndims(datas{1})} = 0;
[domains{:}] = ndgrid(maskedPixelId{:});
% for first fitting just define a background model
if isempty(params.theta0)
    theta0 = cell(numel(datas)+1,1);
    [theta0{:}] = deal({});
    theta0{1} = Kmatrix;
    theta0 = setFirstTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
    theta0 = ensureBkndThetasPos(theta0);
else
    if isempty(params.theta0{1})
        theta0 = cell(numel(datas)+1,1);
        [theta0{:}] = deal({});
        theta0{1} = Kmatrix;
        theta0 = setFirstTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
        theta0 = ensureBkndThetasPos(theta0);
    else
        theta0 = params.theta0{1};
        
    end
end

maxThetaInputs = cellfunNonUniformOutput(@(x) bgkdnOnlyThetas(x),theta0);
% setup inputs-------
A1s = estimated.A1;
% replicate camera variance maps for each channel
if ~iscell(camVar)
    camVars = cell(numel(datas),1);
    [camVars{:}] = deal(camVar);
end
states = cell(params.numSpots,1);

states{1}     = MLEbyIterationV2(objKerns,A1s,carvedMask,datas,theta0,camVars,domains,{{maxThetaInputs,1}},params);
states{1}.thetaMLEsByGrad    = states{1}.thetaMLEs;
states{1}.logLikePPGrad      = states{1}.logLikePP;
states{1}.logLikePGGrad      = states{1}.logLikePG;

states{1}.thetaMLEsByHybrid   = states{1}.thetaMLEs;
states{1}.logLikePPHybrid     = states{1}.logLikePP;
states{1}.logLikePGHybrid     = states{1}.logLikePG;


theta0ByGrad = cell(params.numSpots,1);
for ii = 1:params.numSpots
    if isempty(params.theta0)
%         if isNanTheta(theta0)
%             break;
%         end
        theta0                  = findNextTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
        theta0                  = ensureBkndThetasPos(theta0);
    else
        theta0 = params.theta0{ii+1};
    end
    
    maxThetaInputs          = cellfunNonUniformOutput(@(x) maxAllThetas(x),theta0);
    %% first by gradient
    stateByGrad             = MLEbyIterationV2(objKerns,A1s,carvedMask,datas,theta0,camVars,domains,{{maxThetaInputs,params.gradSteps}},params);
    states{ii+1}            = stateByGrad;
    theta0ByGrad{ii}        = stateByGrad.thetaMLEs;
    
    if ~isequal(stateByGrad.stateOfStep,'ok')
        states{ii+1}.thetaMLEsByGrad        = {};
        states{ii+1}.logLikePPGrad          = 0;
        states{ii+1}.logLikePGGrad          = 0;
        states{ii+1}.thetaMLEsByHybrid      = {};
        states{ii+1}.logLikePPHybrid        = 0;
        states{ii+1}.logLikePGHybrid        = 0;
        break;
    end
    
    if params.hybridSteps > 0
        maxThetaInputsHybrid    = cellfunNonUniformOutput(@(x) hybridAllThetas(x),theta0);
        stateByHybrid       = MLEbyIterationV2(objKerns,A1s,carvedMask,datas,stateByGrad.thetaMLEs,camVars,domains,{{maxThetaInputsHybrid,params.hybridSteps}},params,'prevIter',params.gradSteps);
        if ~isequal(stateByHybrid.stateOfStep,'ok')
            states{ii+1}.stateOfStep            = stateByHybrid.stateOfStep;
            states{ii+1}.thetaMLEsByGrad        = theta0ByGrad{ii};
            states{ii+1}.logLikePPGrad          = stateByGrad.logLikePP;
            states{ii+1}.logLikePGGrad          = stateByGrad.logLikePG;
            states{ii+1}.thetaMLEsByHybrid      = {};
            states{ii+1}.logLikePPHybrid        = 0;
            states{ii+1}.logLikePGHybrid        = 0;
            break;
        end
    end
    
    if params.newtonSteps > 0
        newtonBuild             = newtonRaphsonBuild(maxThetaInputs);
        stateByNewt             = MLEbyIterationV2(objKerns,A1s,carvedMask,datas,stateByHybrid.thetaMLEs,camVars,domains,{{newtonBuild,params.newtonSteps}},params,'prevIter',params.gradSteps+params.hybridSteps);
        if ~isequal(stateByNewt.stateOfStep,'ok')
            states{ii+1}                        = stateByHybrid;
            states{ii+1}.stateOfStep            = stateByNewt.stateOfStep;
            states{ii+1}.thetaMLEsByGrad        = theta0ByGrad{ii};
            states{ii+1}.logLikePPGrad          = stateByGrad.logLikePP;
            states{ii+1}.logLikePGGrad          = stateByGrad.logLikePG;
            states{ii+1}.thetaMLEsByHybrid      = stateByHybrid.thetaMLEs;
            states{ii+1}.logLikePPHybrid        = stateByHybrid.logLikePP;
            states{ii+1}.logLikePGHybrid        = stateByHybrid.logLikePG;
            %         display('break at newton');
            break;
        end
    end
    if params.newtonSteps > 0 && params.hybridSteps > 0
        states{ii+1}                        = stateByNewt;
        states{ii+1}.thetaMLEsByGrad        = theta0ByGrad{ii};
        states{ii+1}.logLikePPGrad          = stateByGrad.logLikePP;
        states{ii+1}.logLikePGGrad          = stateByGrad.logLikePG;
        states{ii+1}.thetaMLEsByHybrid      = stateByHybrid.thetaMLEs;
        states{ii+1}.logLikePPHybrid        = stateByHybrid.logLikePP;
        states{ii+1}.logLikePGHybrid        = stateByHybrid.logLikePG;
    else
        states{ii+1}.thetaMLEsByGrad        = stateByGrad.thetaMLEs;
        states{ii+1}.logLikePPGrad          = stateByGrad.logLikePP;
        states{ii+1}.logLikePGGrad          = stateByGrad.logLikePG;
        states{ii+1}.thetaMLEsByHybrid      = {};
        states{ii+1}.logLikePPHybrid        = 0;
        states{ii+1}.logLikePGHybrid        = 0;
    end
    theta0 = stateByGrad.thetaMLEs;
end
states = deleteEmptyCells(states);
states = cell2mat(states);

