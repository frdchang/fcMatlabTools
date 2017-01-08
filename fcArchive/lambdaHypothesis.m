function [lambdas,Dlambdas,D2lambdas] = lambdaHypothesis(domains,thetaList,varargin)
%LAMBDAHYPOTHESIS will generate the lambda hypothesis over the domains =
%{x,y,z...} given thetaList which is organized as follows
%
% thetaList = {hypothesis for dataset1, hypothesis for dataset2}
% 
% with
%
% hypothesis for dataset1 = {{pattern object, its theta},{pattern object,
% its other theta},{Background level}}
%
% this allows for multiple patterns with bleed through in multilple
% datasets.  
%
% when there is multiple datasets and bleed through you need to define the
% bleed through parameters by a matrix
%
% 'bleedThru', [b11,b12; b21 b22]
%
% the rows sum up to 1
%
% the output is the sum of {hypothesis for dataset1, hypothesis for dataset2}
% with each bleedthru.  

%--parameters--------------------------------------------------------------
params.bleedThru     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numChannels = size(params.bleedThru,2);
% generate bleed thru data for each channels
lambdas = cell(numChannels,1);
[lambdas{:}] = deal(0);
for eachChannel = 1:numel(thetaList)
    currentPatterns = genPatternsFromThetas(domains,thetaList{eachChannel});
    % for each bleedthrough
    for eachBleedThru = 1:size(numChannels,2)
        lambdas{eachBleedThru} = lambdas{eachBleedThru} + params.bleedThru(eachChannel,eachBleedThru)*currentPatterns;
    end
end

