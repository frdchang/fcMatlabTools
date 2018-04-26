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
%
% additionally, there are spot models that occur for 2 colors. 
% i will assume spot models go from {kmatrix,g,r}
% [g],[r], [g g], [r,r] [g r], [r,g]
% each condition needs a threshold to be defined
% {[],[],[],[],[],[]}
% so a cell array will trigger this thesholding conditions
% 
% i am going to hard code this for 2 colors only. if it works, generalize
% to n colors later


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

if iscell(params.spotthresh)
   spotSelected = [];
   thetas = {spotStruct.thetaMLEs};
   okstates = strcmp({spotStruct.stateOfStep},'ok');
   g_states = cellfun(@(x) numel(x{2}),thetas)>1;
   r_states = cellfun(@(x) numel(x{3}),thetas)>1;
   
   switch binaryVectorToDec(okstates)
       case 7
           % second spot is good
           switch binaryVectorToDec([g_states r_states])
               case 11 % r g
               
               case 25 % g r
                   
               case 24 % gg
                   
               case 3  % r r
                   
               otherwise
           end
       case 6
           % first spot is good
           
       case 4
           % only bkgnd is good
           
       otherwise
   end
   return; 
end

% select states that are 'ok'
states = {spotStruct.stateOfStep};
okstates = strcmp(states,'ok');
spotStruct(~okstates) = [];
LLs = [spotStruct.(params.field)];

% curate spotthresh
params.spotthresh = [0 ;params.spotthresh(:)];
params.spotthresh(~okstates(1:min(numel(params.spotthresh),numel(okstates)))) = [];
% 
LLRatios = LLs - LLs(1);
permissiveOnes = arrayfun(@(x) find(LLRatios>=x),params.spotthresh,'UniformOutput',false);

% idx = [];
% for ii = 1:numel(permissiveOnes)
%    if ~isempty(permissiveOnes{ii})
%        if  permissiveOnes{ii}(1)== ii
%           idx =ii; 
%        end
%    end
% end

idx  = LLRatios(:) > params.spotthresh(:);
idx  = find(idx >0,1,'last');
if isempty(idx)
    spotSelected = [];
else
    spotSelected = spotStruct(idx);

end
end

