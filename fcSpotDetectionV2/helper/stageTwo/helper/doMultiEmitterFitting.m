function [ states ] = doMultiEmitterFitting(datas,sigmasqs,domains,kMatrix,estimated,candidates,kernObjs,varargin)
%DOMULTIEMITTERFITTING will iteratively do multi emitter fitting

%--parameters--------------------------------------------------------------
params.numSpots     = 3;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

states = cell(params.numSpots,1);

% for first fitting just find the highest LLRatio as theta0


for ii = 2:params.numSpots
    % take error measurement
    
    % generate theta0
    
    % to iterative fitting
    
end
%state = MLEbyIterationV2(datas,theta0s,sigmasqs,domains,strategy,varargin)
end

