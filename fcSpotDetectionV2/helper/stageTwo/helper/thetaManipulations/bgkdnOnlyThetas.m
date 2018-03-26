function [ maxThetas ] = bgkdnOnlyThetas( thetaInputs )
%HYBRIDALLTHETAS Summary of this function goes here
%   Detailed explanation goes here

if isempty(thetaInputs)
    maxThetas = {};
    return;
end

if ismatrix(thetaInputs) && ~iscell(thetaInputs)
   maxThetas = zeros(size(thetaInputs)); 
   return;
end

numThetas = numel(thetaInputs);
maxThetas = cell(1,numThetas);
for ii = 1:numThetas
    if iscell(thetaInputs)
        currInpute = thetaInputs{ii};
        if isscalar(currInpute)
            maxThetas{ii} = 2;
        else
            argumentList = currInpute{2:end};
            maxThetas{ii} = zeros(size(argumentList));
        end
    end
end


