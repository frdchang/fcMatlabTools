function [h,conditionHolder] = analyzeStageIFPRPlot(benchStruct,conditionFunc,field,varargin)
% first plots cdf
% then it plots overlap percentage
% then it plots global ROC for A>=B
%--parameters--------------------------------------------------------------
params.fitGamma         = false;
params.NumBinsMAX       = 200;
params.contourLineSig   = 0.05;
params.contourLines     = 0.05:0.05:0.5;
params.minAForGlobalROC = 0;
params.noEdgeEffects    = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

conditionFunc = func2str(conditionFunc);

if ~isfield(benchStruct,conditionFunc)
    error(['need to run ' conditionFunc ' directFitting bench']);
end

[ ~,saveFolder ] = genProcessedPathForBench(benchStruct,'analyzeStageI');
if params.noEdgeEffects
    saveFolder = [saveFolder filesep 'noEdgeEffects'];
else
    saveFolder = [saveFolder filesep 'withEdgeEffects'];
end

makeDIR(saveFolder);

myMin                   = 0.1;
conditions              = benchStruct.(conditionFunc);
% stage I analysis only applies to distance = 0
sizeAB                  = [size(conditions,1) size(conditions,2)];
idxConditions           = zeros(size(conditions));
idxConditions(:,:,1)    = 1;
conditions              = conditions(logical(idxConditions));

conditionHolder         = cell(size(conditions));
currMin                 = inf;
currMax                 = -inf;

close all;
%--------------------------------------------------------------------------
disp('analyzeStageI(): extracting data');
setupParForProgress(prod(sizeAB));
for ii = 1:prod(sizeAB)
    incrementParForProgress();
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    currD = conditions{ii}.D;
    if isfield(conditions{ii},conditionFunc)
        currFuncConditions = conditions{ii}.(conditionFunc);
    else
        currFuncConditions = conditions{ii}.(field);
    end
    %% extract the signal and bkgnd
    sig = zeros(numel(currFuncConditions),1);
    bk  = cell(numel(currFuncConditions),1);
    for jj = 1:numel(currFuncConditions)
        if iscell(currFuncConditions{jj})
            tempLoad = currFuncConditions{jj};
            tempLoad = tempLoad{1};
            currFuncOutput = importStack(tempLoad);
            
        else
            currFuncOutput = load(currFuncConditions{jj});
            currFuncOutput=  currFuncOutput.x;
            currFuncOutput = currFuncOutput.(field);
            
        end
        
        % if is a cell that means its multi color, so just measure from
        % channel 1
        if iscell(currFuncOutput)
            currFuncOutput = currFuncOutput{1};
            [sig(jj),bk{jj}] = measureSigBkgnd(currFuncOutput,benchStruct.centerCoor,getPatchSize(benchStruct.psfs{1}),params.noEdgeEffects);
        else
            [sig(jj),bk{jj}] = measureSigBkgnd(currFuncOutput,benchStruct.centerCoor,getPatchSize(benchStruct.psfs{1}),params.noEdgeEffects);
        end
    end
    bk = cell2mat(bk);
    conditionHolder{ii}.sig = sig;
    conditionHolder{ii}.bk  = bk;
    minSig = min(sig);
    maxSig = max(sig);
    minBK  = min(bk);
    maxBK  = max(bk);
    minMin = min(minSig,minBK);
    maxMax = max(maxSig,maxBK);
    if currMin > minMin
        currMin = minMin;
    end
    if currMax < maxMax
        currMax = maxMax;
    end
end
%--------------------------------------------------------------------------
% myTitle = ['log pdf' filesep conditionFunc ' ' field ' log pdf'];
% h = createFullMaxFigure(myTitle);
% minA = inf;
% minB = inf;
% maxA = -inf;
% maxB = -inf;
% Adomain = zeros(sizeAB);
% Bdomain = zeros(sizeAB);
% disp('analyzeStageI(): plotting log pdf scale');
% setupParForProgress(prod(sizeAB));
% for ii = 1:prod(sizeAB)
%     incrementParForProgress();
%     currA = conditions{ii}.A;
%     currB = conditions{ii}.B;
%     Adomain(ii) = currA;
%     Bdomain(ii) = currB;
%     sig = conditionHolder{ii}.sig + currMin + myMin;
%     bk = conditionHolder{ii}.bk+ currMin + myMin;
%     subplot(sizeAB(2),sizeAB(1),ii);
%     [hSig,hBk ] = histSigBkgnd(sig,bk,'NumBinsMAX',params.NumBinsMAX);
%     hSig.Normalization = 'pdf';
%     hBk.Normalization = 'pdf';
%     hBk.EdgeColor = 'none';
%     hSig.EdgeColor = 'none';
%     set(gca,'YScale','log');
%     title(['A' num2str(currA) ' B' num2str(currB)]);
%     if currA < minA
%         minA = currA;
%     end
%     if currA > maxA
%         maxA = currA;
%     end
%     if currB < minB
%         minB = currB;
%     end
%     if currB > maxB
%         maxB = currB;
%     end
%     axis tight;
%     drawnow;
% end
% legend('bk','sig');

% minXaxis = inf;
% maxXaxis = -inf;
% minYaxis = inf;
% maxYaxis = -inf;
% for ii = 1:prod(sizeAB)
%     hold on;subplot(sizeAB(2),sizeAB(1),ii);
%     V = axis;
%     if minXaxis > V(1)
%         minXaxis = V(1);
%     end
%     if maxXaxis < V(2)
%         maxXaxis = V(2);
%     end
%     if minYaxis > V(3)
%         minYaxis = V(3);
%     end
%     if maxYaxis < V(4)
%         maxYaxis = V(4);
%     end
% end
% 

% for ii = 1:prod(sizeAB)
%     hold on;subplot(sizeAB(2),sizeAB(1),ii);
%     if currMin < -1 || currMax == -Inf
%         axis([minXaxis maxXaxis minYaxis maxYaxis]);
%     else
%         axis([myMin 10^ceil(log10(currMax))  minYaxis maxYaxis]);
%         set(gca,'XScale','log');
%     end
% end
% 
% exportFigEPS([saveFolder filesep myTitle]);
% close all;
%--------------------------------------------------------------------------
% myTitle = ['logcdf' filesep conditionFunc ' ' field ' logcdf'];
% h = createFullMaxFigure(myTitle);
% minA = inf;
% minB = inf;
% maxA = -inf;
% maxB = -inf;
% Adomain = zeros(sizeAB);
% Bdomain = zeros(sizeAB);
% disp('analyzeStageI(): plotting cdf log scale');
% setupParForProgress(prod(sizeAB));
% for ii = 1:prod(sizeAB)
%     incrementParForProgress();
%     currA = conditions{ii}.A;
%     currB = conditions{ii}.B;
%     Adomain(ii) = currA;
%     Bdomain(ii) = currB;
%     sig = conditionHolder{ii}.sig + currMin + myMin;
%     bk = conditionHolder{ii}.bk+ currMin + myMin;
%     subplot(sizeAB(2),sizeAB(1),ii);
%     [hSig,hBk ] = histSigBkgnd(sig,bk,'NumBinsMAX',params.NumBinsMAX);
%     hSig.Normalization = 'cdf';
%     hBk.Normalization = 'cdf';
%     hBk.EdgeColor = 'none';
%     hSig.EdgeColor = 'none';
%     title(['A' num2str(currA) ' B' num2str(currB)]);
%     if currA < minA
%         minA = currA;
%     end
%     if currA > maxA
%         maxA = currA;
%     end
%     if currB < minB
%         minB = currB;
%     end
%     if currB > maxB
%         maxB = currB;
%     end
%     axis tight;
%     set(gca,'YScale','log');
%     drawnow;
% end
% legend('bk','sig');
% 
% exportFigEPS([saveFolder filesep myTitle]);
% 
% myTitle = ['loglogcdf' filesep conditionFunc ' ' field ' loglogcdf'];
% 
% if currMin >= -1 
%     for ii = 1:prod(sizeAB)
%         hold on;subplot(sizeAB(2),sizeAB(1),ii);
%         axis([myMin 10^ceil(log10(currMax)) 0 1]);
%         set(gca,'XScale','log');
%     end
%     
%     exportFigEPS([saveFolder filesep myTitle]);
% end
% close all;
%--------------------------------------------------------------------------
disp('analyzeStageI(): processing EER');
ii = 1;
    %     display(ii);
    incrementParForProgress();
    sig = conditionHolder{ii}.sig;
    bk = conditionHolder{ii}.bk;
    Baxis(ii) = conditions{ii}.B;
    %     pause(1);
    ROC = genROC('adsf',sig,bk,'doPlot',true);

end

% loglog(Baxis,myFPR,'-x');xlabel('B');ylabel('measured FPR');
% axis([min(Baxis) max(Baxis) 0.001 1]);
% myTitle = ['bkgnd sensitivity: ' conditionFunc];
% exportFigEPS([saveFolder filesep myTitle]);

    
