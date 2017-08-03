function [ spotSelected ] = spotSelectorByThresh( spotStruct ,varargin)
%SPOTSELECTORBYTHRESH will select the proper spot by the threshold defined
%below for the spot Struct returned by stage ii.
%
% if there is multi spot fitting then 
% the spot selected will be the first one to pass the highest threshold
%     LLs     = [0 10 60 105];
% e.g LLRatio = [10 50 55]
%     thresh  = [5  45 70]
% 
%     ok?     =[ok, ok, not not]
%
%     LLS     = [0 10]
%     LLRatio = 10
%     thresh  = 5
% since 50 is > 45  the spot corresponding to this position will be
% selected
%
% it also makes sure all the stateOfSteps is ok

%--parameters--------------------------------------------------------------
params.field         = 'logLikePP';
params.spotthresh    = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if isempty(params.spotthresh)
   if strcmp(spotStruct(2).stateOfStep,'ok')
      spotSelected = spotStruct(2); 
   else
      spotSelected = []; 
   end
   return;
end

% select states that are 'ok'
states = {spotStruct.stateOfStep};
okstates = strcmp(states,'ok');
spotStruct(~okstates) = [];
LLs = [spotStruct.(params.field)];

% curate spotthresh
params.spotthresh(~okstates(1:min(numel(params.spotthresh),numel(okstates)))) = [];
% 
LLRatios = LLs - LLs(1);
permissiveOnes = arrayfun(@(x) find(LLRatios>=x),params.spotthresh,'UniformOutput',false);

idx = [];
for ii = 1:numel(permissiveOnes)
   if ~isempty(permissiveOnes{ii})
       if  permissiveOnes{ii}(1)== ii
          idx =ii; 
       end
   end
end
if isempty(idx)
    spotSelected = [];
else
    spotSelected = spotStruct(idx);

end
end

