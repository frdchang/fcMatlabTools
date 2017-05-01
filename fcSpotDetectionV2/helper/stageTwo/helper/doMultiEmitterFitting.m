function [ states ] = doMultiEmitterFitting(carvedMask,maskedPixelId,datas,estimated,camVar,Kmatrix,objKerns,varargin)
%DOMULTIEMITTERFITTING will iteratively do multi emitter fitting

%--parameters--------------------------------------------------------------
params.numSpots     = 2;
params.gradSteps    = 4000;
params.newtonSteps  = 100;
params.doPlotEveryN = 100;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

states = cell(params.numSpots+1,1);
domains{ndims(datas{1})} = 0;
[domains{:}] = ndgrid(maskedPixelId{:});
% for first fitting just define a background model
theta0 = cell(numel(datas)+1,1);
[theta0{:}] = deal({});
theta0{1} = Kmatrix;
theta0 = setFirstTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
maxThetaInputs = cellfunNonUniformOutput(@(x) bgkdnOnlyThetas(x),theta0);
% setup inputs-------
A1s = estimated.A1;
% replicate camera variance maps for each channel
if ~iscell(camVar)
    camVars = cell(numel(datas),1);
    [camVars{:}] = deal(camVar);
end
states{1}     = MLEbyIterationV2(A1s,carvedMask,datas,theta0,camVars,domains,{{maxThetaInputs,1}},'doPlotEveryN',inf);



theta0 = cell(numel(datas)+1,1);
[theta0{:}] = deal({});
theta0{1} = Kmatrix;
for ii = 1:params.numSpots
    theta0 = findNextTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
    maxThetaInputs = cellfunNonUniformOutput(@(x) hybridAllThetas(x),theta0);
    newtonBuild    = newtonRaphsonBuild(maxThetaInputs);
    states{ii+1}     = MLEbyIterationV2(A1s,carvedMask,datas,theta0,camVars,domains,{{maxThetaInputs,params.gradSteps},{newtonBuild,params.newtonSteps}},'doPlotEveryN',params.doPlotEveryN);
    if ~isequal(states{ii+1}.stateOfStep,'ok')
        break;
    end
    theta0 = states{ii+1}.thetaMLEs;
    
end



