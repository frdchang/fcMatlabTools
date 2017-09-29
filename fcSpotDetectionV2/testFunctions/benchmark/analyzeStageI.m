function [h,conditionHolder] = analyzeStageI(benchStruct,conditionFunc,field,varargin)
% first plots cdf
% then it plots overlap percentage
% then it plots global ROC for A>=B
%--parameters--------------------------------------------------------------
params.fitGamma         = false;
params.NumBinsMAX       = 200;
params.contourLineSig   = 0.05;
params.contourLines     = 0.05:0.05:0.5;
params.minAForGlobalROC = 0;
params.noEdgeEffects    = false;
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
myTitle = ['log pdf' filesep conditionFunc ' ' field ' log pdf'];
h = createFullMaxFigure(myTitle);
minA = inf;
minB = inf;
maxA = -inf;
maxB = -inf;
Adomain = zeros(sizeAB);
Bdomain = zeros(sizeAB);
disp('analyzeStageI(): plotting log pdf scale');
setupParForProgress(prod(sizeAB));
for ii = 1:prod(sizeAB)
    incrementParForProgress();
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    Adomain(ii) = currA;
    Bdomain(ii) = currB;
    sig = conditionHolder{ii}.sig + currMin + myMin;
    bk = conditionHolder{ii}.bk+ currMin + myMin;
    subplot(sizeAB(2),sizeAB(1),ii);
    [hSig,hBk ] = histSigBkgnd(sig,bk,'NumBinsMAX',params.NumBinsMAX);
    hSig.Normalization = 'pdf';
    hBk.Normalization = 'pdf';
    hBk.EdgeColor = 'none';
    hSig.EdgeColor = 'none';
    set(gca,'YScale','log');
    title(['A' num2str(currA) ' B' num2str(currB)]);
    if currA < minA
        minA = currA;
    end
    if currA > maxA
        maxA = currA;
    end
    if currB < minB
        minB = currB;
    end
    if currB > maxB
        maxB = currB;
    end
    axis tight;
    drawnow;
end
legend('bk','sig');

minXaxis = inf;
maxXaxis = -inf;
minYaxis = inf;
maxYaxis = -inf;
for ii = 1:prod(sizeAB)
    hold on;subplot(sizeAB(2),sizeAB(1),ii);
    V = axis;
    if minXaxis > V(1)
        minXaxis = V(1);
    end
    if maxXaxis < V(2)
        maxXaxis = V(2);
    end
    if minYaxis > V(3)
        minYaxis = V(3);
    end
    if maxYaxis < V(4)
        maxYaxis = V(4);
    end
end


for ii = 1:prod(sizeAB)
    hold on;subplot(sizeAB(2),sizeAB(1),ii);
    if currMin < -1 || currMax == -Inf
        axis([minXaxis maxXaxis minYaxis maxYaxis]);
    else
        axis([myMin 10^ceil(log10(currMax))  minYaxis maxYaxis]);
        set(gca,'XScale','log');
    end
end

exportFigEPS([saveFolder filesep myTitle]);
close all;
%--------------------------------------------------------------------------
myTitle = ['logcdf' filesep conditionFunc ' ' field ' logcdf'];
h = createFullMaxFigure(myTitle);
minA = inf;
minB = inf;
maxA = -inf;
maxB = -inf;
Adomain = zeros(sizeAB);
Bdomain = zeros(sizeAB);
disp('analyzeStageI(): plotting cdf log scale');
setupParForProgress(prod(sizeAB));
for ii = 1:prod(sizeAB)
    incrementParForProgress();
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    Adomain(ii) = currA;
    Bdomain(ii) = currB;
    sig = conditionHolder{ii}.sig + currMin + myMin;
    bk = conditionHolder{ii}.bk+ currMin + myMin;
    subplot(sizeAB(2),sizeAB(1),ii);
    [hSig,hBk ] = histSigBkgnd(sig,bk,'NumBinsMAX',params.NumBinsMAX);
    hSig.Normalization = 'cdf';
    hBk.Normalization = 'cdf';
    hBk.EdgeColor = 'none';
    hSig.EdgeColor = 'none';
    title(['A' num2str(currA) ' B' num2str(currB)]);
    if currA < minA
        minA = currA;
    end
    if currA > maxA
        maxA = currA;
    end
    if currB < minB
        minB = currB;
    end
    if currB > maxB
        maxB = currB;
    end
    axis tight;
    set(gca,'YScale','log');
    drawnow;
end
legend('bk','sig');

exportFigEPS([saveFolder filesep myTitle]);

myTitle = ['loglogcdf' filesep conditionFunc ' ' field ' loglogcdf'];

if currMin >= -1 
    for ii = 1:prod(sizeAB)
        hold on;subplot(sizeAB(2),sizeAB(1),ii);
        axis([myMin 10^ceil(log10(currMax)) 0 1]);
        set(gca,'XScale','log');
    end
    
    exportFigEPS([saveFolder filesep myTitle]);
end
close all;
%--------------------------------------------------------------------------
disp('analyzeStageI(): processing EER');
setupParForProgress(prod(sizeAB));
myEER = zeros(sizeAB);
for ii = 1:prod(sizeAB)
    %     display(ii);
    incrementParForProgress();
    sig = conditionHolder{ii}.sig;
    bk = conditionHolder{ii}.bk;
    %     pause(1);
    ROC = genROC('adsf',sig,bk,'doPlot',false);
    %     pause(1);
    close all;
    myEER(ii) = ROC.EER;
end
close all;
imagesc([minA,maxA],[minB,maxB],myEER');colorbar;title(myTitle);xlabel('A');ylabel('B');
caxis([0 0.5]);
myTitle = ['EER heatmap' filesep conditionFunc ' ' field ' EER heatmap'];

if sizeAB(1) > 1 && sizeAB(2) > 1
    
    hold on;
    [newA,newB] = meshgrid(minA:0.1:maxA,minB:0.1:maxB);
    F = scatteredInterpolant(Adomain(:),Bdomain(:),myEER(:));
    F.Method = 'natural';
    hold on;[C,h] = contour(newA,newB,F(newA,newB),[params.contourLineSig,params.contourLineSig],'LineWidth',3, 'Color',[1 1 1 ]);
    clabel(C,h,'Color',[1 1 1],'FontSize',15);
    set(gca,'Ydir','reverse');
    axis equal;
    exportFigEPS([saveFolder filesep myTitle 'wContour']);
    close all;
    %--------------------------------------------------------------------------
    
    myTitle = ['EER contour' filesep conditionFunc ' ' field ' EER contour'];
    [C,h]=contour(newA,newB,F(newA,newB),params.contourLines,'LineWidth',3,'ShowText','on');
    % clabel(C,h,'Color',[1 1 1],'FontSize',15);
    set(gca,'Ydir','reverse');
    axis equal;
    title(myTitle);xlabel('A');ylabel('B');
    exportFigEPS([saveFolder filesep myTitle]);
    close all;
end
%--------------------------------------------------------------------------
disp('analyzeStageI(): global ROC...');
sigHolder = cell(prod(sizeAB),1);
bkHolder  = cell(prod(sizeAB),1);
for ii = 1:prod(sizeAB)
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    if currA <= params.minAForGlobalROC
        continue;
    end
    display(['A:' num2str(currA) ',B:' num2str(currB)]);
    sigHolder{ii} = conditionHolder{ii}.sig;
    bkHolder{ii} = conditionHolder{ii}.bk;
end
sigHolder = cell2mat(sigHolder);
bkHolder = cell2mat(bkHolder);
if ~isempty(sigHolder) && ~isempty(bkHolder)
    ROC = genROC(['global ROC' filesep conditionFunc ' ' field ' global ROC'],sigHolder,bkHolder,'doPlot',true);
    figure(ROC.histHandle);
    pause(1);
    myTitle = ['ROC-histograms' filesep conditionFunc ' ' field ' ROC-histograms'];
    exportFigEPS([saveFolder filesep myTitle]);
    figure(ROC.CDFHandle);
    myTitle = ['ROC-CDFs' filesep conditionFunc ' ' field ' ROC-CDFs'];
    exportFigEPS([saveFolder filesep myTitle]);
    pause(1);
    figure(ROC.ROCHandle);
    pause(1);
    myTitle = ['ROC' filesep conditionFunc ' ' field ' ROC'];
    exportFigEPS([saveFolder filesep myTitle]);
    close all;
end

%--------------------------------------------------------------------------
disp('analyzeStageI(): global ROC...');
sigHolder = cell(prod(sizeAB),1);
bkHolder  = cell(prod(sizeAB),1);
for ii = 1:prod(sizeAB)
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    if currA ==0 || currA > currB
        continue;
    end
    display(['A:' num2str(currA) ',B:' num2str(currB)]);
    sigHolder{ii} = conditionHolder{ii}.sig;
    bkHolder{ii} = conditionHolder{ii}.bk;
end
sigHolder = cell2mat(sigHolder);
bkHolder = cell2mat(bkHolder);
if ~isempty(sigHolder) && ~isempty(bkHolder)
    ROC = genROC([conditionFunc ' ' field 'global ROC'],sigHolder,bkHolder,'doPlot',true);
    figure(ROC.histHandle);
    myTitle = ['ROC-histograms-AlessthenB' filesep conditionFunc ' ' field ' ROC-histograms-AlessthenB'];
    exportFigEPS([saveFolder filesep myTitle]);
    figure(ROC.CDFHandle);
    myTitle = ['ROC-CDFs-AlessthenB' filesep conditionFunc ' ' field ' ROC-CDFs-AlessthenB'];
    exportFigEPS([saveFolder filesep myTitle]);
    pause(1);
    figure(ROC.ROCHandle);
    pause(1);
    myTitle = ['ROC-AlessthenB' filesep conditionFunc ' ' field ' ROC-AlessthenB'];
    exportFigEPS([saveFolder filesep myTitle]);
    close all;
end
close all;
%--------------------------------------------------------------------------
disp('analyzeStageI(): analyze if bkgnd shifts...');
bkHolder  = {};
Bvals  = {};
for ii = 1:prod(sizeAB)
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    if currA ~= 0
        continue;
    end
    display(['A:' num2str(currA) ',B:' num2str(currB)]);
    bkHolder{ii} = conditionHolder{ii}.bk;
    Bvals{ii} = currB;
end
close all;
if ~isempty(bkHolder)
    figure;
    for ii = numel(bkHolder):-1:1
        hold on; h = histogram(bkHolder{ii},'DisplayStyle','stairs');
        h.Normalization = 'pdf';
    end
    legend(cellfunNonUniformOutput(@num2str,Bvals));
    xlabel([conditionFunc ' ' field ' values']);
    
    ylabel('log pdf');
    title('bkgnd pdf at different Bs');
    set(gca,'YScale','log');
    
    if currMin > -1
        set(gca,'XScale','log');
    end
    
    myTitle = ['bkgndCreepLogPDF' filesep conditionFunc ' ' field ' bkgndCreepLogPDF'];
    exportFigEPS([saveFolder filesep myTitle]);
    close all;
end
if params.fitGamma
    %% fit gamma distribution
    h = createFullMaxFigure([conditionFunc ' pdf background and gamma fit']);
    bkShape = zeros(sizeAB);
    bkScale = zeros(sizeAB);
    for ii = 1:prod(sizeAB)
        currA = conditions{ii}.A;
        currB = conditions{ii}.B;
        %     sig = conditionHolder{ii}.sig + currMin + myMin;
        bk = conditionHolder{ii}.bk;
        bk(bk<=0) = [];
        subplot(sizeAB(2),sizeAB(1),ii);
        hBk  = histogram(bk);
        phat = gamfit(bk);
        hBk.Normalization = 'pdf';
        hold on;
        plot(hBk.BinEdges,gampdf(hBk.BinEdges,phat(1),phat(2)),'LineWidth',2);
        hBk.EdgeColor = 'none';
        set(gca,'XScale','log');
        title({['A' num2str(currA) ' B' num2str(currB)],[sprintf('%0.2f',phat(1)) ',' sprintf('%0.2f',phat(2))]});
        axis tight;
        bkShape(ii) = phat(1);
        bkScale(ii) = phat(2);
    end
    myTitle = [conditionFunc ' ' field];
    print('-painters','-depsc', [saveFolder filesep myTitle '-pdf background and gamma fit']);
    figure;imagesc([minA,maxA],[minB,maxB],bkShape');colorbar;title('bk shape');xlabel('A');ylabel('B');
    print('-painters','-depsc', [saveFolder filesep myTitle '-bkshape']);
    figure;imagesc([minA,maxA],[minB,maxB],bkScale');colorbar;title('bk scale');xlabel('A');ylabel('B');
    print('-painters','-depsc', [saveFolder filesep myTitle '-bkscale']);
    f=figure;
    xx = linspace(minB,maxB,size(bkScale,2));
    yy = bkScale(1,:);
    [curve, goodness] = fit( xx', yy', 'poly1' );
    hold on;plot(curve,xx,yy);title(['bkscale w psfSize' mat2str(size(benchStruct.psfs{1}))]);xlabel('B');ylabel('scale');
    text(0.2*maxB,0.8*max(yy),sprintf('%0.3f x + %0.3f',curve.p1, curve.p2));
    print('-painters','-depsc', [saveFolder filesep myTitle '-bkscaleVsB']);
    saveas(f,[saveFolder filesep myTitle '-bkscaleVsB.fig']);
    
    close all;
    %% fit gamma distribution
    h = createFullMaxFigure([conditionFunc ' pdf signal ']);
    sigShape = zeros(sizeAB);
    sigScale = zeros(sizeAB);
    xx = [];
    yy = [];
    for ii = 1:prod(sizeAB)
        currA = conditions{ii}.A;
        currB = conditions{ii}.B;
        sig = conditionHolder{ii}.sig;
        sig(sig<=0) = [];
        subplot(sizeAB(2),sizeAB(1),ii);
        hBk  = histogram(sig);
        phat = gamfit(sig);
        hBk.Normalization = 'pdf';
        hold on;
        plot(hBk.BinEdges,gampdf(hBk.BinEdges,phat(1),phat(2)),'LineWidth',2);
        hBk.EdgeColor = 'none';
        title({['A' num2str(currA) ' B' num2str(currB)],[sprintf('%0.2f',phat(1)) ',' sprintf('%0.2f',phat(2))]});
        axis tight;
        sigShape(ii) = phat(1);
        sigScale(ii) = phat(2);
        xx(end+1) = currB;
        yy(end+1) = currA;
    end
    aspectRatio = (maxA-minA)/(maxB-minB);

    print('-painters','-depsc', [saveFolder filesep myTitle '-pdf signal and gamma fit']);
    figure;imagesc([minA,maxA],[minB,maxB],sigShape');colorbar;title('sig shape');xlabel('A');ylabel('B');pbaspect([aspectRatio 1 1]);

    print('-painters','-depsc', [saveFolder filesep myTitle '-sigShape']);
    figure;imagesc([minA,maxA],[minB,maxB],sigScale');colorbar;title('sig scale');xlabel('A');ylabel('B');pbaspect([aspectRatio 1 1]);

    print('-painters','-depsc', [saveFolder filesep myTitle '-sigScale']);
    close all;
    
    [shapeFit] = fit([xx',yy'],sigShape(:),'poly11');
    [scaleFit] = fit([xx',yy'],sigScale(:),'poly11');
    plot(shapeFit,[xx',yy'],sigShape(:));xlabel('B');ylabel('A');title(['shapeFit(B,A) = ' num2str(shapeFit.p00) ' + ' num2str(shapeFit.p10) '*B + ' num2str(shapeFit.p01) ' *A']);
    print('-painters','-depsc', [saveFolder filesep myTitle '-sigShapeFit']);
    close all;
    plot(scaleFit,[xx',yy'],sigScale(:));xlabel('B');ylabel('A');title(['scaleFit(B,A) = ' num2str(scaleFit.p00) ' + ' num2str(scaleFit.p10) '*B + ' num2str(scaleFit.p01) ' *A']);
    print('-painters','-depsc', [saveFolder filesep myTitle '-sigScaleFit']);
    close all;
end

% for A=18 B 12 find threshold then replot the stuff
idx = sub2ind(sizeAB,7,3);
thisA = conditions{idx}.A;
thisB = conditions{idx}.B;
sig = conditionHolder{idx}.sig;
bk  = conditionHolder{idx}.bk;
ROC = genROC([conditionFunc ' ' field 'global ROC'],sig,bk,'doPlot',false);
threshold_idx = find(ROC.withoutTargetCDF > 0.99,1,'first');
threshold = ROC.newDomain(threshold_idx);
fp = NaN(sizeAB);
tp = NaN(sizeAB);
for ii = 1:prod(sizeAB)
    %     display(ii);
    incrementParForProgress();
    sig = conditionHolder{ii}.sig;
    bk = conditionHolder{ii}.bk;
    %     pause(1);
    ROC = genROC('adsf',sig,bk,'doPlot',false);
    tp_curr = 1-ROC.withTargetCDF(find(ROC.newDomain > threshold,1,'first'));
    fp_curr = 1-ROC.withoutTargetCDF(find(ROC.newDomain > threshold,1,'first'));
    if ~isempty(tp_curr)
    tp(ii) = tp_curr;
    end
    if ~isempty(fp_curr)
    fp(ii) = fp_curr; 
    end
    close all;
end

aspectRatio = (maxA-minA)/(maxB-minB);

figure;imagesc([minA,maxA],[minB,maxB],tp');colorbar;title(['tp: ' num2str(thisA) ',' num2str(thisB)]);xlabel('A');ylabel('B');
pbaspect([aspectRatio 1 1]);
exportFigEPS([saveFolder filesep 'tp_fp' filesep conditionFunc '_tp']);
close all;
figure;imagesc([minA,maxA],[minB,maxB],fp');colorbar;title(['fp: ' num2str(thisA) ',' num2str(thisB)]);xlabel('A');ylabel('B');
pbaspect([aspectRatio 1 1]);
exportFigEPS([saveFolder filesep 'tp_fp' filesep conditionFunc '_fp']);
close all;


