function [ states ] = doMultiEmitterFitting(carvedMask,maskedPixelId,datas,estimated,camVar,Kmatrix,objKerns,varargin)
%DOMULTIEMITTERFITTING will iteratively do multi emitter fitting

%--parameters--------------------------------------------------------------
params.numSpots     = 2;
params.gradSteps    = 4000;
params.newtonSteps  = 1000;
params.doPlotEveryN = 100;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

domains{ndims(datas{1})} = 0;
[domains{:}] = ndgrid(maskedPixelId{:});
% for first fitting just define a background model
theta0 = cell(numel(datas)+1,1);
[theta0{:}] = deal({});
theta0{1} = Kmatrix;
theta0 = setFirstTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
maxThetaInputs = cellfunNonUniformOutput(@(x) bgkdnOnlyThetas(x),theta0);
newtonBuild    = newtonRaphsonBuild(maxThetaInputs);
states{ii}     = MLEbyIterationV2(A1s,carvedMask,datas,theta0,camVars,domains,{{newtonBuild,params.newtonSteps}},'doPlotEveryN',params.doPlotEveryN);

% replicate camera variance maps for each channel
if ~iscell(camVar)
    camVars = cell(numel(datas),1);
    [camVars{:}] = deal(camVar);
end


theta0 = cell(numel(datas)+1,1);
[theta0{:}] = deal({});
theta0{1} = Kmatrix;
A1s = estimated.A1;
theta0 = findNextTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
states = cell(params.numSpots,1);
for ii = 1:params.numSpots
    % to iterative fitting
    %     maxThetaInputs = cellfunNonUniformOutput(@(x) maxAllThetas(x),theta0);
    theta0 = findNextTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
    maxThetaInputs = cellfunNonUniformOutput(@(x) hybridAllThetas(x),theta0);
    newtonBuild    = newtonRaphsonBuild(maxThetaInputs);
    states{ii}     = MLEbyIterationV2(A1s,carvedMask,datas,theta0,camVars,domains,{{maxThetaInputs,params.gradSteps},{newtonBuild,params.newtonSteps}},'doPlotEveryN',params.doPlotEveryN);
    if ~isequal(states{ii}.stateOfStep,'ok')
        break;
    end
    theta0 = states{ii}.thetaMLEs;
    
end



