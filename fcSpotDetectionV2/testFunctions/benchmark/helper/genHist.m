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
                           currMean = mean(analysis{ii}.thetaHolder(currTheta,:));
                    currSTD  = std(analysis{ii}.thetaHolder(currTheta,:));
                    nowMax = currMean + currSTD*3;
                    nowMIN = currMean - currSTD*3;
                if currMin > nowMIN
                    currMin = nowMIN;
                end
                if currMax < nowMax
                    currMax = nowMax;
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
                    title([' A:' num2str(currAnalysis{ii}.A) ' B:' num2str(currAnalysis{ii}.B)]);
                    xlabel(num2str(numel(currAnalysis{ii}.thetaHolder(currTheta,:))));
                    currMean = mean(currAnalysis{ii}.thetaHolder(currTheta,:));
                    currSTD  = std(currAnalysis{ii}.thetaHolder(currTheta,:));
                    nowMax = currMean + currSTD*3;
                    nowMIN = currMean - currSTD*3;
                    if currMin > nowMIN
                        currMin = nowMIN;
                    end
                    if currMax < nowMax
                        currMax = nowMax;
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
                        hold on; plot(xDomain,normpdf(xDomain, currAnalysis{ii}.trueTheta(currTheta),currStds(currTheta)),'--','LineWidth',2);
                    end
                end
            end
            exportFigEPS([saveFolder filesep 'histograms' filesep myTitle]);
            %             saveas(hBasket,[saveFolder filesep myTitle],'epsc');
            close all;
        end
        close all;
    otherwise
        error('sizeConditions not 2 or 3');
end

end