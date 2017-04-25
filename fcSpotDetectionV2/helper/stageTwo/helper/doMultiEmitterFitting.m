function [ states ] = doMultiEmitterFitting(maskedPixelId,rectSubArrayIdx,datas,mask,estimated,camVar,Kmatrix,objKerns,varargin)
%DOMULTIEMITTERFITTING will iteratively do multi emitter fitting

%--parameters--------------------------------------------------------------
params.numSpots     = 3;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

states = cell(params.numSpots,1);
domains{3} = 0;
[domains{:}] = ndgrid(maskedPixelId{:});
% for first fitting just find the highest LLRatio as theta0
theta0 = cell(numel(datas)+1,1);
[theta0{:}] = deal({});
theta0{1} = Kmatrix;
theta0 = findNextTheta0(domains,theta0,datas,estimated,camVar,Kmatrix,objKerns);
states = cell(params.numSpots,1);
for ii = 1:params.numSpots
    % to iterative fitting
    maxThetaInputs = maxAllThetas(theta0);
    states{ii} = MLEbyIterationV2(datas,theta0s,sigmasqs,domains,strategy);
end


