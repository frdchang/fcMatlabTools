function [h,analysis] = analyzeStageIIDirect( benchStruct )
%ANALYZESTAGEII will analyze stage ii benchStruct

if ~isfield(benchStruct,'directFitting')
    error('need to run STage ii  directFitting bench');
end
[ ~,saveFolder ] = genProcessedPathForBench( benchStruct,'analyzeStageII');
makeDIR(saveFolder);

stageIIconds = benchStruct.directFitting;
numConds     = numel(stageIIconds);
Kmatrix      = benchStruct.Kmatrix;
analysis     = cell(size(stageIIconds));
minA = inf;
maxA = -inf;
minB = inf;
maxB = -inf;
setupParForProgress(numConds);
for ii = 1:numConds
    incrementParForProgress();
    if isempty(stageIIconds{ii})
        % analysis was not done,e.g. when A=0
    else
        currA        = stageIIconds{ii}.A;
        currB        = stageIIconds{ii}.B;
        currD        = stageIIconds{ii}.D;
        if currA < minA
            minA = currA;
        end
        if currB < minB
            minB = currB;
        end
        if currA > maxA;
            maxA = currA;
        end
        if currB > maxB;
            maxB = currB;
        end
        %         display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(ii) ' of ' num2str(numConds)]);
        
        MLEs         = stageIIconds{ii}.MLEsByDirect;
        
        if isempty(stageIIconds{ii}.bigTheta)
            continue;
        end
        masterTheta  = stageIIconds{ii}.bigTheta;
        trueTheta    = flattenTheta0s(stageIIconds{ii}.bigTheta);
        numSamples   = numel(MLEs);
        
        trueTheta(1:numel(Kmatrix)) = [];
        thetaHolder  = zeros(numel(trueTheta),numSamples);
        LLPPHolder   = zeros(numSamples,1);
        LLPPBasket   = zeros(numSpotsInTheta(masterTheta)+1,numSamples);
        LLPGBasket   = zeros(numSpotsInTheta(masterTheta)+1,numSamples);
        for jj = 1:numSamples
            currMLEholder           = MLEs{jj}{1};
            if ~all(abs([currMLEholder.logLikePP])>0) || numel([currMLEholder.logLikePG]) ~= (numSpotsInTheta(masterTheta)+1)
                continue;
            end
            idxOfMatch = cellfun(@(x) isSameThetaStructure(masterTheta,x),{currMLEholder.thetaMLEs});
            
            if ~any(idxOfMatch)
                continue;
            end
            currMLE = currMLEholder(idxOfMatch);
            if ~isequal(currMLE.stateOfStep,'ok')
                continue;
            end
            LLPPBasket(:,jj) = [currMLEholder.logLikePP];
            LLPGBasket(:,jj) = [currMLEholder.logLikePG];
            LLPPHolder(jj)       = currMLE.logLikePP;
            currMLE              = flattenTheta0s(currMLE.thetaMLEs);
            currMLE(1:numel(Kmatrix)) = [];
            thetaHolder(:,jj)    = currMLE;
        end
        % remove empty thetas in thetaHolder
        %         thetaHolder(:,~any(thetaHolder,1)) = [];
        thetaHolder = thetaHolder(:,LLPPHolder>0);
        LLPPBasket = LLPPBasket(:,LLPPHolder>0);
        LLPGBasket = LLPGBasket(:,LLPPHolder>0);
        LLPPHolder = LLPPHolder(LLPPHolder>0);
        
        analysis{ii}.thetaHolder = thetaHolder;
        analysis{ii}.LLPPHolder  = LLPPHolder;
        analysis{ii}.LLPPBasket  = LLPPBasket;
        analysis{ii}.LLPGBasket  = LLPGBasket;
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




% get std map
stdForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [stdForEachTheta{ii},domains] = applyFunc(stageIIconds,analysis,@std,ii);
end

% for ii = 1:numTheta
%     close all;
%     currTheta = ii;
%     d = 1;
%     [c,h] = contour(domains{1}(:,:,d),domains{2}(:,:,d),stdForEachTheta{currTheta}(:,:,d));
%     set (h, 'LineWidth', 2);
%     myTitle = ['std deviation theta ' num2str(ii)];
%     xlabel('A');ylabel('B');title(myTitle);
%     colorbar;
%     saveas(gcf,[saveFolder filesep myTitle],'epsc');
% end
% close all;

if ismatrix(analysis) == 2
    numDs = 1;
else
    numDs = size(analysis,3);
end
for ii = 1:numTheta
    for currD = 1:numDs
        close all;
        currSTDMap = stdForEachTheta{ii}(:,:,currD);
        if all(isnan(currSTDMap(:)))
            continue;
        end
        minMaxOfDomains = calcMinMaxFromMeshData(domains);
        ADoms = minMaxOfDomains(1,:);
        BDoms = minMaxOfDomains(2,:);
        [newA,newB] = meshgrid(linspace(ADoms(1),ADoms(2),100),linspace(BDoms(1),BDoms(2),100));
        AA = domains{1}(:,:,currD);
        BB = domains{2}(:,:,currD);
        AA(isnan(currSTDMap)) = [];
        BB(isnan(currSTDMap)) = [];
        currSTDMap(isnan(currSTDMap)) = [];
        F = scatteredInterpolant(AA(:),BB(:),currSTDMap(:));
        F.Method = 'natural';
        [C,h] = contour(newA,newB,F(newA,newB),'LineWidth',3,'ShowText','on');
        set(gca,'Ydir','reverse');
        axis equal;
        myTitle = ['std deviation theta ' num2str(ii) ' at d' num2str(currD)];
        title(myTitle);
        xlabel('A');ylabel('B');
        box off;
        print('-painters','-depsc', [saveFolder filesep myTitle]);
    end
end
close all;
% get mean map
meanForEachTheta = cell(numTheta,1);
for ii = 1:numTheta
    [meanForEachTheta{ii},~] = applyFunc(stageIIconds,analysis,@mean,ii);
end

% gen histogram maps
histograms = cell(numTheta,1);
for ii = 1:numTheta
    histograms{ii} = genHist(analysis,ii,saveFolder,stdForEachTheta,meanForEachTheta);
end

%% do LLRatio CDFS
sizeConditions = size(analysis);
switch numel(sizeConditions)
    case 2
        currAnalysis = analysis;
        currDFirst = getFirstNonEmptyCellContent(analysis);
        myTitle = ['LLRatio CDF - distance ' num2str(currD) ' theta(' mat2str(currDFirst.trueTheta(:)') ')'];
        hBasket = createFullMaxFigure(myTitle);
        currSizeConditions = size(currAnalysis);
        for ii = 1:prod(currSizeConditions)
            if ~isempty(currAnalysis{ii}) && ~isempty(currAnalysis{ii}.LLPPBasket)
                subplot(currSizeConditions(2), currSizeConditions(1),ii);
                currLLR = currAnalysis{ii}.LLPPBasket;
                currLLR = bsxfun(@minus,currLLR,currLLR(1,:));
                currLLR(1,:) = [];
                for jj = 1:size(currLLR,1)
                    jjSpotLLR = currLLR(jj,:);
                    jjSpotLLR(imag(jjSpotLLR) > 0) = [];
                    hold on;hSub = histogram(jjSpotLLR);
                    hSub.Normalization = 'pdf';
                    axis tight;
                end
                title([num2str(ii) ' A:' num2str(currAnalysis{ii}.A) ' B:' num2str(currAnalysis{ii}.B)]);
                xlabel(num2str(numel(currLLR(jj,:))));
            end
        end
        print('-painters','-depsc', [saveFolder filesep myTitle]);
        saveas(hBasket,[saveFolder filesep myTitle],'epsc');
        close all;
        
    case 3
        for di = 1:sizeConditions(3)
            currAnalysis = analysis(:,:,di);
            currDFirst = getFirstNonEmptyCellContent(currAnalysis);
            currD = currDFirst.D;
            myTitle = ['LLRatio CDF - distance ' num2str(currD) ' theta(' mat2str(currDFirst.trueTheta(:)') ')'];
            hBasket = createFullMaxFigure(myTitle);
            currSizeConditions = size(currAnalysis);
            for ii = 1:prod(currSizeConditions)
                %                 display(ii);
                if ~isempty(currAnalysis{ii}) && ~isempty(currAnalysis{ii}.LLPPBasket)
                    subplot(currSizeConditions(2), currSizeConditions(1),ii);
                    currLLR = currAnalysis{ii}.LLPPBasket;
                    currLLR = bsxfun(@minus,currLLR,currLLR(1,:));
                    currLLR(1,:) = [];
                    for jj = 1:size(currLLR,1)
                        jjSpotLLR = currLLR(jj,:);
                        jjSpotLLR(imag(jjSpotLLR) > 0) = [];
                        hold on;hSub = histogram(jjSpotLLR);
                        hSub.Normalization = 'pdf';
                        axis tight;
                        
                    end
                    title([num2str(ii) ' A:' num2str(currAnalysis{ii}.A) ' B:' num2str(currAnalysis{ii}.B)]);
                    xlabel(num2str(numel(currLLR(jj,:))));
                end
            end
            print('-painters','-depsc', [saveFolder filesep myTitle]);
            
            %             saveas(hBasket,[saveFolder filesep myTitle],'epsc');a
            close all;
        end
        close all;
    otherwise
        error('sizeConditions not 2 or 3');
end

end

function hBasket = genHist(analysis,currTheta,saveFolder,stdForEachTheta,meanForEachTheta)
minBinLimits = 1;
sizeConditions = size(analysis);
close all;
currMin = inf;
currMax = -inf;
peakMax = -inf;
currStd = stdForEachTheta{currTheta};
currMean = meanForEachTheta{currTheta};
switch numel(sizeConditions)
    case 2
        currDFirst = getFirstNonEmptyCellContent(analysis);
        myTitle = [' theta' num2str(currTheta) ' of ' mat2str(currDFirst.trueTheta(:)')];
        hBasket = createFullMaxFigure(myTitle);
        currSizeConditions = size(analysis);
        for ii = 1:prod(currSizeConditions)
            if ~isempty(analysis{ii})
                subplot(currSizeConditions(2), currSizeConditions(1),ii);
                hSub = histogram(analysis{ii}.thetaHolder(currTheta,:));
                hSub.Normalization = 'pdf';
                if currMin > min(hSub.BinEdges)
                    currMin = min(hSub.BinEdges);
                end
                if currMax < max(hSub.BinEdges)
                    currMax = max(hSub.BinEdges);
                end
                if abs(diff(hSub.BinLimits)) > minBinLimits
                    if peakMax < max(hSub.Values)
                        peakMax = max(hSub.Values);
                    end
                end
                title(['A:' num2str(analysis{ii}.A) ' B:' num2str(analysis{ii}.B)]);
                xlabel(num2str(numel(analysis{ii}.thetaHolder(currTheta,:))));
            end
        end
        
        if currMin ~= inf && currMax ~= -inf && peakMax ~= -inf;
            for ii = 1:prod(currSizeConditions)
                if ~isempty(analysis{ii})
                    subplot(currSizeConditions(2), currSizeConditions(1),ii);
                    axis([currMin currMax 0 peakMax]);
                    xDomain = linspace(currMin,currMax,100);
                    hold on; plot(xDomain,normpdf(xDomain,currMean(ii),currStd(ii)));
                end
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
            hBasket = createFullMaxFigure(myTitle);
            
            currSizeConditions = size(currAnalysis);
            for ii = 1:prod(currSizeConditions)
                if ~isempty(currAnalysis{ii})
                    subplot(currSizeConditions(2), currSizeConditions(1),ii);
                    hSub = histogram(currAnalysis{ii}.thetaHolder(currTheta,:));
                    hSub.Normalization = 'pdf';
                    title([num2str(ii) ' A:' num2str(currAnalysis{ii}.A) ' B:' num2str(currAnalysis{ii}.B)]);
                    xlabel(num2str(numel(currAnalysis{ii}.thetaHolder(currTheta,:))));
                    if currMin > min(hSub.BinEdges)
                        currMin = min(hSub.BinEdges);
                    end
                    if currMax < max(hSub.BinEdges)
                        currMax = max(hSub.BinEdges);
                    end
                    if abs(diff(hSub.BinLimits)) > minBinLimits
                        
                        if peakMax < max(hSub.Values)
                            peakMax = max(hSub.Values);
                        end
                    end
                end
            end
            if currMin ~= inf && currMax ~= -inf && peakMax ~= -inf;
                
                for ii = 1:prod(currSizeConditions)
                    if ~isempty(analysis{ii})
                        subplot(currSizeConditions(2), currSizeConditions(1),ii);
                        axis([currMin currMax 0 peakMax]);
                        xDomain = linspace(currMin,currMax,100);
                        hold on; plot(xDomain,normpdf(xDomain,currMean(ii),currStd(ii)));
                    end
                end
            end
            print('-painters','-depsc', [saveFolder filesep myTitle]);
            %             saveas(hBasket,[saveFolder filesep myTitle],'epsc');
            close all;
        end
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
            stdMap(ii) =  myFunc(myData);
        end
    end
end
domains{3} = conditionD;
domains{2} = conditionB;
domains{1} = conditionA;
end

