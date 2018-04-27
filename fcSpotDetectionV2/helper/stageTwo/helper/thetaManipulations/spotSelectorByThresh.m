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
% select states that are 'ok'
states = {spotStruct.stateOfStep};
okstates = strcmp(states,'ok');

if iscell(params.spotthresh)
    spotSelected = [];
    thetas = {spotStruct.thetaMLEs};
    g_states = cellfun(@(x) numel(x{2}),thetas)>1;
    r_states = cellfun(@(x) numel(x{3}),thetas)>1;
    
    switch binaryVectorToDec(okstates)
        case 7
            % second spot is good
            switch binaryVectorToDec([g_states r_states])
                case 11 % r g
                    %disp('rg');
                    spotthresh = params.spotthresh{6};
                case 25 % g r
                    %disp('gr');
                    spotthresh = params.spotthresh{5};
                case 24 % g g
                     %disp('gg');
                    spotthresh = params.spotthresh{3};
                case 3  % r r
                     %disp('rr');
                    spotthresh = params.spotthresh{4};
                otherwise
                    error('asdf');
            end
        case 6
            % first spot is good
            % need to program for the case when there is only 1 successful
            % convergence
            error('asadsfadsfdf');
        case 4
            % only bkgnd is good
            
        otherwise
    end
else
    spotthresh = params.spotthresh;
end


spotStruct(~okstates) = [];
LLs = [spotStruct.(params.field)];

% curate spotthresh
spotthresh = [0 ; spotthresh(:)];
spotthresh(~okstates(1:min(numel(spotthresh),numel(okstates)))) = [];
LLRatios = LLs - LLs(1);

% permissiveOnes = arrayfun(@(x) find(LLRatios>=x),spotthresh,'UniformOutput',false);
% idx = [];
% for ii = 1:numel(permissiveOnes)
%    if ~isempty(permissiveOnes{ii})
%        if  permissiveOnes{ii}(1)== ii
%           idx =ii;
%        end
%    end
% end

idx  = LLRatios(:) > spotthresh(:);
idx  = find(idx >0,1,'last');
if isempty(idx)
    spotSelected = [];
    %dispaly('none');
else
    %display(idx);
    spotSelected = spotStruct(idx);
end
end

