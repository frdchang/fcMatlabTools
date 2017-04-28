function [ states ] = doMultiEmitterFitting(carvedMask,maskedPixelId,datas,estimated,camVar,Kmatrix,objKerns,varargin)
%DOMULTIEMITTERFITTING will iteratively do multi emitter fitting

%--parameters--------------------------------------------------------------
params.numSpots     = 5;
params.gradSteps    = 4000;
params.newtonSteps  = 1000;
params.doPlotEveryN = 100;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

domains{numel(datas)} = 0;
[domains{:}] = ndgrid(maskedPixelId{:});
% for first fitting just find the highest LLRatio as theta0
theta0 = cell(numel(datas)+1,1);
[theta0{:}] = deal({});
theta0{1} = Kmatrix;
theta0 = findNextTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
states = cell(params.numSpots,1);

% replicate camera variance maps for each channel
if ~iscell(camVar)
    camVars = cell(numel(datas),1);
    [camVars{:}] = deal(camVar);
end

A1s = estimated.A1;
for ii = 1:params.numSpots
    % to iterative fitting
    maxThetaInputs = cellfunNonUniformOutput(@(x) maxAllThetas(x),theta0);
    newtonBuild    = newtonRaphsonBuild(maxThetaInputs);
    states{ii}     = MLEbyIterationV2(A1s,carvedMask,datas,theta0,camVars,domains,{{maxThetaInputs,params.gradSteps},{newtonBuild,params.newtonSteps}},'doPlotEveryN',params.doPlotEveryN);
    theta0 = states{ii}.thetaMLEs;
    theta0 = findNextTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
end

display('done');


