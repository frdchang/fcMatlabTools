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
        analysis{ii}.A           = currA;
        analysis{ii}.B           = currB;
        analysis{ii}.D           = currD;
    end
end

% histograms
% iterate over distances, numspots, conditions
numTheta      =  getFirstNonEmptyCellContent(analysis);
numTheta      =  size(numTheta.thetaHolder,2);



% gen histogram maps
histograms = cell(numTheta,1);
for ii = 1:numTheta
    histograms{ii} = genHist(analysis,ii);
end


% get std map
stdForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [stdForEachTheta{ii},domains] = applyFunc(stageIIconds,analysis,@std,ii);
end

for ii = 1:numTheta
    figure;
    currTheta = ii;
    d = 1;
    contour(domains{1}(:,:,d),domains{2}(:,:,d),stdForEachTheta{currTheta}(:,:,d));
    xlabel('A');ylabel('B');title(['std deviation theta ' num2str(ii)]);
end

% get mean map
meanForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [meanForEachTheta{ii},~] = applyFunc(stageIIconds,analysis,@mean,ii);
end



end

function hBasket = genHist(analysis,currTheta)
sizeConditions = size(analysis);
for di = 1:sizeConditions(3)
    currAnalysis = analysis(:,:,di);
    currDFirst = getFirstNonEmptyCellContent(currAnalysis);
    currD = currDFirst.D;
    hBasket{di} = createMaxFigure(['distance:' num2str(currD) ' theta(' num2str(currTheta) ') of ' num2str(currDFirst.trueTheta(:)')]);
    
    currSizeConditions = size(currAnalysis);
    for ii = 1:prod(currSizeConditions)
        if ~isempty(currAnalysis{ii})
            subplot(currSizeConditions(1), currSizeConditions(2),ii);
            hSub = histogram(currAnalysis{ii}.thetaHolder(currTheta,:));
            hSub.Normalization = 'pdf';
            title(['A:' num2str(currAnalysis{ii}.A) ' B:' num2str(currAnalysis{ii}.B)]);
        end
    end
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

