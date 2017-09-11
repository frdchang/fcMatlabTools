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
        if currA > maxA
            maxA = currA;
        end
        if currB > maxB
            maxB = currB;
        end
        %         display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(ii) ' of ' num2str(numConds)]);
        
        MLEs         = stageIIconds{ii}.MLEsByDirect;
        
        if isempty(stageIIconds{ii}.bigTheta) || all(cellfun(@isempty,MLEs))
            continue;
        end
        masterTheta  = stageIIconds{ii}.bigTheta;
        stdErrorList     = benchStruct.conditions{ii}.stdErrorList;
        trueTheta    = flattenTheta0s(stageIIconds{ii}.bigTheta);
        numSamples   = numel(MLEs);
        
        trueTheta(1:numel(Kmatrix)) = [];
        thetaHolder  = zeros(numel(trueTheta),numSamples);
        LLPPHolder   = zeros(numSamples,1);
        LLPPBasket   = zeros(numSpotsInTheta(masterTheta)+1,numSamples);
        LLPGBasket   = zeros(numSpotsInTheta(masterTheta)+1,numSamples);
        for jj = 1:numSamples
            currMLEholder           = MLEs{jj}{1};
            %             currMLEholder           = MLEs{jj};
            if ~all(abs([currMLEholder.logLikePP])>0)
                continue;
            end
            
            % number of stable localization is less than the number of
            % spots
            if numel([currMLEholder.logLikePP]) ~= (numSpotsInTheta(masterTheta)+1)
                LLPPBasket(1:numel([currMLEholder.logLikePP]),jj) = [currMLEholder.logLikePP];
                LLPGBasket(1:numel([currMLEholder.logLikePG]),jj) = [currMLEholder.logLikePG];
                LLPPBasket(numel([currMLEholder.logLikePP])+1,jj) = currMLEholder(end).logLikePP;
                LLPGBasket(numel([currMLEholder.logLikePG])+1,jj) = currMLEholder(end).logLikePG;
                currMLE  = currMLEholder(end);
                LLPPHolder(jj)       = currMLE.logLikePP;
                continue;
            end
            idxOfMatch = cellfun(@(x) isSameThetaStructure(masterTheta,x),{currMLEholder.thetaMLEs});
            
            if ~any(idxOfMatch)
                continue;
            end
            currMLE = currMLEholder(idxOfMatch);
            if ~isequal(currMLE.stateOfStep,'ok')
                LLPPBasket(:,jj) = [currMLEholder.logLikePP];
                LLPGBasket(:,jj) = [currMLEholder.logLikePG];
                LLPPBasket(end,jj) = LLPPBasket(end-1,jj);
                LLPGBasket(end,jj) = LLPGBasket(end-1,jj);
                LLPPHolder(jj)       = currMLE.logLikePP;
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
        thetaHolder = thetaHolder(:,LLPPHolder>0);
        stdErrorList = stdErrorList(LLPPHolder>0);
        thetaHolder(:,~any(thetaHolder,1)) = [];
        LLPPBasket  = LLPPBasket(:,LLPPHolder>0);
        LLPGBasket  = LLPGBasket(:,LLPPHolder>0);
        LLPPHolder  = LLPPHolder(LLPPHolder>0);
        
        analysis{ii}.stdErrorList = stdErrorList;
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

% % % % % % for ii = 1:numTheta
% % % % % %     close all;
% % % % % %     currTheta = ii;
% % % % % %     d = 1;
% % % % % %     [c,h] = contour(domains{1}(:,:,d),domains{2}(:,:,d),stdForEachTheta{currTheta}(:,:,d));
% % % % % %     set (h, 'LineWidth', 2);
% % % % % %     myTitle = ['std deviation theta ' num2str(ii)];
% % % % % %     xlabel('A');ylabel('B');title(myTitle);
% % % % % %     colorbar;
% % % % % %     saveas(gcf,[saveFolder filesep myTitle],'epsc');
% % % % % % end
% % % % % % close all;

currSizeConditions = size(analysis(:,:,1));

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
        [newA,newB] = meshgrid(linspace(ADoms(1),ADoms(2),10),linspace(BDoms(1),BDoms(2),10));
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

%% plot EER for different distances
if ndims(analysis) == 3
    for ii = 1:size(analysis,1)
        for jj = 1:size(analysis,2)
            analysis_D = analysis(ii,jj,:);
            if all(~cellfun(@isempty,analysis_D))
                currEER = zeros(numel(analysis_D),1);
                currD = zeros(numel(analysis_D),1);
                for di = 1:numel(analysis_D)
                    currLLR = analysis_D{di}.LLPPBasket;
                    currLLR = bsxfun(@minus,currLLR,currLLR(1,:));
                    ROC = genROC(['A:' analysis_D{di}.A 'B:' analysis_D{di}.B],currLLR(3,:),currLLR(2,:),'doPlot',false);
                    currEER(di) = ROC.EER;
                    currD(di) = analysis_D{di}.D;
                end
                close all;
                myTitle = ['EERoverD' filesep 'EER-A_' num2str(analysis_D{di}.A) ' B_' num2str(analysis_D{di}.B)];
                makeDIRforFilename([saveFolder filesep myTitle]);
                plot(currD,currEER,'-*');xlabel('Distance');ylabel('EER');title(['A:' num2str(analysis_D{di}.A) ' B:' num2str(analysis_D{di}.B)]);            axis([min(currD) max(currD) 0 0.5]);
                print('-painters','-depsc', [saveFolder filesep myTitle]);
            end
        end
    end
    close all;
end

%% plot global EER
myTitle = ['EERoverDGlobal' filesep 'EERglobal'];
makeDIRforFilename([saveFolder filesep myTitle]);
createFullMaxFigure();
if ndims(analysis) == 3
    for ii = 1:size(analysis,1)
        for jj = 1:size(analysis,2)
            analysis_D = analysis(ii,jj,:);
            if all(~cellfun(@isempty,analysis_D))
                currEER = zeros(numel(analysis_D),1);
                currD = zeros(numel(analysis_D),1);
                for di = 1:numel(analysis_D)
                    currLLR = analysis_D{di}.LLPPBasket;
                    currLLR = bsxfun(@minus,currLLR,currLLR(1,:));
                    ROC = genROC(['A:' analysis_D{di}.A 'B:' analysis_D{di}.B],currLLR(3,:),currLLR(2,:),'doPlot',false);
                    currEER(di) = ROC.EER;
                    currD(di) = analysis_D{di}.D;
                end
                subplot(currSizeConditions(2), currSizeConditions(1),sub2ind(currSizeConditions,ii,jj));                
                plot(currD,currEER,'-*');xlabel('Distance');ylabel('EER');title(['A:' num2str(analysis_D{di}.A) ' B:' num2str(analysis_D{di}.B)]);            axis([min(currD) max(currD) 0 0.5]);
            end
        end
    end
                    print('-painters','-depsc', [saveFolder filesep myTitle]);
close all;
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
                hSub.EdgeColor  = 'none';
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
        
        if currMin ~= inf && currMax ~= -inf && peakMax ~= -inf
            for ii = 1:prod(currSizeConditions)
                if ~isempty(analysis{ii})
                    subplot(currSizeConditions(2), currSizeConditions(1),ii);
                    axis([currMin currMax 0 peakMax]);
                    xDomain = linspace(currMin,currMax,100);
                    currErrors = cell2mat(cellfun(@(x) x',analysis{ii}.stdErrorList,'uni',false));
                    currStds = sqrt(mean(currErrors.^2,1));
                    hold on; plot(xDomain,normpdf(xDomain, analysis{ii}.trueTheta(currTheta),currStds(currTheta)));
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
                    hSub.EdgeColor  = 'none';
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
            if currMin ~= inf && currMax ~= -inf && peakMax ~= -inf
                
                for ii = 1:prod(currSizeConditions)
                    if ~isempty(currAnalysis{ii})
                        subplot(currSizeConditions(2), currSizeConditions(1),ii);
                        axis([currMin currMax 0 peakMax]);
                        xDomain = linspace(currMin,currMax,100);
                        currErrors = cell2mat(cellfun(@(x) x',currAnalysis{ii}.stdErrorList,'uni',false));
                        currStds = sqrt(mean(currErrors.^2,1));
                        hold on; plot(xDomain,normpdf(xDomain, currAnalysis{ii}.trueTheta(currTheta),currStds(currTheta)));
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

