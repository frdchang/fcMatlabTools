function [ spotSelected ] = spotSelectorByThresh( spotStruct ,varargin)
%SPOTSELECTORBYTHRESH will select the proper spot by the threshold defined
%below for the spot Struct returned by stage ii.
%
% if there is multi spot fitting then 
% the spot selected will be the first one to pass the highest threshold
%
% e.g LLRatio = [10 50 55]
%     thresh  = [5  45 70]
%
% since 50 is > 45  the spot corresponding to this position will be
% selected
%
% it also makes sure all the stateOfSteps is ok

%--parameters--------------------------------------------------------------
params.field     = 'logLikePP';
params.thresh    = 0;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% 
states = {spotStruct.stateOfStep};
okstates = strcmp(states,'ok');
spotStruct(~okstates) = [];
LLs = [spotStruct.(params.field)];
% 
LLRatios = LLs - LLs(1);

permissiveOnes = LLRatios > params.thresh;
idx = find(permissiveOnes,1,'first');
spotSelected = spotStruct(idx);
end

