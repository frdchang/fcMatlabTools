function [h,analysis] = analyzeStageII( benchStruct )
%ANALYZESTAGEII will analyze stage ii benchStruct

if ~isfield(benchStruct,'MLEbyIterationV2')
    error('need to run STage ii bench');
end

stageIIconds = benchStruct.MLEbyIterationV2;
numConds     = numel(stageIIconds);
Kmatrix      = benchStruct.Kmatrix;
analysis     = cell(size(stageIIconds));
for ii = 1:numConds
    if isempty(stageIIconds{ii})
        % analysis was not done,e.g. when A=0
    else
        currA        = stageIIconds{ii}.A;
        currB        = stageIIconds{ii}.B;
        currD        = stageIIconds{ii}.D;
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(ii) ' of ' num2str(numConds)]);
        
        states       = stageIIconds{ii}.state;
        trueTheta    = flattenTheta0s(stageIIconds{ii}.bigTheta);
        numSamples   = numel(states);
        
        trueTheta(1:numel(Kmatrix)) = [];
        thetaHolder  = zeros(numel(trueTheta),numSamples);
        LLPPHolder   = zeros(numSamples,1);
        
        for jj = 1:numSamples
            currStates           = states{jj};
            LLPPHolder(jj)       = currStates.logLikePP;
            currMLE              = flattenTheta0s(currStates.thetaMLEs);
            currMLE(1:numel(Kmatrix)) = [];
            thetaHolder(:,jj)    = currMLE;
        end
        analysis{ii}.thetaHolder = thetaHolder;
        analysis{ii}.LLPPHolder  = LLPPHolder;
        analysis{ii}.trueTheta   = trueTheta;
    end
end

% histograms
% iterate over distances, numspots, conditions
numTheta      =  getFirstNonEmptyCellContent(analysis);
numTheta      =  size(numTheta.thetaHolder,2);
sizeConditions = size(stageIIconds);

% get std map
stdForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [stdForEachTheta{ii},domains] = applyFunc(stageIIconds,analysis,@std,ii);
end

% get mean map
meanForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [meanForEachTheta{ii},~] = applyFunc(stageIIconds,analysis,@mean,ii);
end
end

function [stdMap,domains] = applyFunc(stageIIconds,analysis,myFunc,currTheta)

sizeConditions = size(analysis);
stdMap = zeros(sizeConditions);
conditionA = zeros(sizeConditions);
conditionB = zeros(sizeConditions);
conditionD = zeros(sizeConditions);
for ii = 1:numel(stdMap)
    if isempty(analysis{ii})
        stdMap(ii) = nan;
        conditionA(ii) = nan;
        conditionB(ii) = nan;
        conditionD(ii) = nan;
    else
        conditionA(ii) = stageIIconds{ii}.A;
        conditionB(ii) = stageIIconds{ii}.B;
        conditionD(ii) = stageIIconds{ii}.D;
        stdMap(ii) =  myFunc(analysis{ii}.thetaHolder(currTheta,:));
    end
end
domains{3} = conditionD;
domains{2} = conditionB;
domains{1} = conditionA;
end

