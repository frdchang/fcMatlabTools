function [h,analysis] = analyzeStageIIvariance( benchStruct )
%ANALYZESTAGEII will analyze stage ii benchStruct

if ~isfield(benchStruct,'MLEbyIterationV2')
    error('need to run STage ii bench');
end
[ procRoot,saveFolder ] = genProcessedPathForBench( benchStruct,'analyzeStageII');
makeDIR(saveFolder);
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
        
        MLEs         = stageIIconds{ii}.MLEs;
        masterTheta  = stageIIconds{ii}.bigTheta;
        trueTheta    = flattenTheta0s(stageIIconds{ii}.bigTheta);
        numSamples   = numel(MLEs);
        
        trueTheta(1:numel(Kmatrix)) = [];
        thetaHolder  = zeros(numel(trueTheta),numSamples);
        LLPPHolder   = zeros(numSamples,1);
        
        for jj = 1:numSamples
            currMLE           = MLEs{jj}{1};
            idxOfMatch = cellfun(@(x) isSameThetaStructure(masterTheta,x),{currMLE.thetaMLEs});
            
            if ~any(idxOfMatch)
                continue;
            end
            currMLE = currMLE(idxOfMatch);
            if ~isequal(currMLE.stateOfStep,'ok')
                continue;
            end
            
            LLPPHolder(jj)       = currMLE.logLikePP;
            currMLE              = flattenTheta0s(currMLE.thetaMLEs);
            currMLE(1:numel(Kmatrix)) = [];
            thetaHolder(:,jj)    = currMLE;
        end
        % remove empty thetas in thetaHolder
        %         thetaHolder(:,~any(thetaHolder,1)) = [];
        thetaHolder = thetaHolder(:,LLPPHolder>0);
        LLPPHolder = LLPPHolder(LLPPHolder>0);
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
numTheta      =  size(numTheta.thetaHolder,1);

% gen histogram maps
% histograms = cell(numTheta,1);
% for ii = 1:numTheta
%     histograms{ii} = genHist(analysis,ii,saveFolder);
% end


% get std map
stdForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [stdForEachTheta{ii},domains] = applyFunc(stageIIconds,analysis,@std,ii);
end

for ii = 1:numTheta
    close all;
    currTheta = ii;
    d = 1;
    [c,h] = contour(domains{1}(:,:,d),domains{2}(:,:,d),stdForEachTheta{currTheta}(:,:,d));
    set (h, 'LineWidth', 2);
    myTitle = ['std deviation theta ' num2str(ii)];
    xlabel('A');ylabel('B');title(myTitle);
    colorbar;
    saveas(gcf,[saveFolder filesep myTitle],'epsc');
end

% get mean map
meanForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [meanForEachTheta{ii},~] = applyFunc(stageIIconds,analysis,@mean,ii);
end



end

function hBasket = genHist(analysis,currTheta,saveFolder)
sizeConditions = size(analysis);
close all;
switch numel(sizeConditions)
    case 2
        currDFirst = getFirstNonEmptyCellContent(analysis);
        myTitle = [' theta' num2str(currTheta) ' of ' mat2str(currDFirst.trueTheta(:)')];
        hBasket = createMaxFigure(myTitle);
        
        currSizeConditions = size(analysis);
        for ii = 1:prod(currSizeConditions)
            if ~isempty(analysis{ii})
                subplot(currSizeConditions(1), currSizeConditions(2),ii);
                hSub = histogram(analysis{ii}.thetaHolder(currTheta,:));
                hSub.Normalization = 'pdf';
                title(['A:' num2str(analysis{ii}.A) ' B:' num2str(analysis{ii}.B)]);
            end
        end
        saveas(hBasket,[saveFolder filesep myTitle],'epsc');
        close all;
        
    case 3
        for di = 1:sizeConditions(3)
            currAnalysis = analysis(:,:,di);
            currDFirst = getFirstNonEmptyCellContent(currAnalysis);
            currD = currDFirst.D;
            myTitle = ['distance ' num2str(currD) ' theta ' num2str(currTheta) ' of ' mat2str(currDFirst.trueTheta(:)')];
            hBasket = createMaxFigure(myTitle);
            
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
        saveas(hBasket,[saveFolder filesep myTitle],'epsc');
        close all;
    otherwise
        error('sizeConditions not 2 or 3');
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
        myData = analysis{ii}.thetaHolder(currTheta,:);
        if isempty(myData)
            stdMap(ii) =  NaN;
        else
            myData
            stdMap(ii) =  myFunc(myData);
        end
    end
end
domains{3} = conditionD;
domains{2} = conditionB;
domains{1} = conditionA;
end
