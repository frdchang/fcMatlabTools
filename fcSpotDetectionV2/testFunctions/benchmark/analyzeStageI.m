function [h,conditionHolder] = analyzeStageI(benchStruct,conditionFunc,field,varargin)
% first plots cdf
% then it plots overlap percentage
% then it plots global ROC for A>=B
%--parameters--------------------------------------------------------------
params.fitGamma         = false;
params.NumBinsMAX       = 1000;
params.contourLines     = [0.05];
params.minAForGlobalROC = 0;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

conditionFunc = func2str(conditionFunc);
%ANALYZESTAGEI will analyze the stageI output
myMin = 0.1;
conditions = benchStruct.(conditionFunc);
sizeAB = [size(conditions,1) size(conditions,2)];
idxConditions = zeros(size(conditions));
idxConditions(:,:,1) = 1;
conditions = conditions(logical(idxConditions));


conditionHolder = cell(size(conditions));
currMin = inf;
currMax = -inf;
disp('analyzeStageI(): extracting data');
setupParForProgress(prod(sizeAB));
for ii = 1:prod(sizeAB)
    incrementParForProgress();
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    currD = conditions{ii}.D;
    currFuncConditions = conditions{ii}.(conditionFunc);
    %% extract the signal and bkgnd
    sig = zeros(numel(currFuncConditions),1);
    bk  = cell(numel(currFuncConditions),1);
    for jj = 1:numel(currFuncConditions)
        currFuncOutput = load(currFuncConditions{jj});
        currFuncOutput=  currFuncOutput.x;
        
        currFuncOutput = currFuncOutput.(field);
        % if is a cell that means its multi color, so just measure from
        % channel 1
        if iscell(currFuncOutput)
            currFuncOutput = currFuncOutput{1};
            [sig(jj),bk{jj}] = measureSigBkgnd(currFuncOutput,benchStruct.centerCoor,size(benchStruct.psfs{1}));
            
        else
            [sig(jj),bk{jj}] = measureSigBkgnd(currFuncOutput,benchStruct.centerCoor,size(benchStruct.psfs{1}));
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

h = createMaxFigure([conditionFunc ' ' field ' cdf log']);
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
    drawnow;
    axis tight;
    
end
legend('bk','sig');

for ii = 1:prod(sizeAB)
    hold on;subplot(sizeAB(2),sizeAB(1),ii);
    axis([myMin 10^ceil(log10(currMax)) 0 1]);
    set(gca,'XScale','log');
end

disp('analyzeStageI(): plotting cdf raw');
setupParForProgress(prod(sizeAB));

h = createMaxFigure([conditionFunc ' ' field ' cdf raw']);
Adomain = zeros(sizeAB);
Bdomain = zeros(sizeAB);
for ii = 1:prod(sizeAB)
    incrementParForProgress();
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    Adomain(ii) = currA;
    Bdomain(ii) = currB;
    sig = conditionHolder{ii}.sig;
    bk = conditionHolder{ii}.bk;
    subplot(sizeAB(2),sizeAB(1),ii);
    [hSig,hBk ] = histSigBkgnd(sig,bk,'NumBinsMAX',params.NumBinsMAX);
    
    hBk.Normalization = 'cdf';
    hSig.Normalization = 'cdf';
    hBk.EdgeColor = 'none';
    hSig.EdgeColor = 'none';
    title(['A' num2str(currA) ' B' num2str(currB)]);
    axis tight;
    drawnow;
end
legend('bk','sig');

disp('analyzeStageI(): processing EER');
setupParForProgress(prod(sizeAB));
myEER = zeros(sizeAB);
for ii = 1:prod(sizeAB)
    incrementParForProgress();
    sig = conditionHolder{ii}.sig;
    %sig = min(realmax-1,sig);
    bk = conditionHolder{ii}.bk;
    %bk = min(realmax,bk);
    subplot(sizeAB(2),sizeAB(1),ii);
    ROC = genROC('adsf',sig,bk,'doPlot',false);
    myEER(ii) = ROC.EER;
end
figure;imagesc([minA,maxA],[minB,maxB],myEER');colorbar;title([conditionFunc ' ' field 'EER']);xlabel('A');ylabel('B');
caxis([0 0.5]);
%
% % draw contour plot version
% hold on;[C,h] = contour(Adomain,Bdomain,myEER,[params.contourLines,0.5],'LineWidth',3, 'Color',[1 1 1 ]);
% clabel(C,h,'Color',[1 1 1],'FontSize',15);
% set(gca,'Ydir','reverse');
% axis equal;

hold on;
[newA,newB] = meshgrid(minA:0.1:maxA,minB:0.1:maxB);
F = scatteredInterpolant(Adomain(:),Bdomain(:),myEER(:));
F.Method = 'natural';
hold on;[C,h] = contour(newA,newB,F(newA,newB),[params.contourLines,params.contourLines],'LineWidth',3, 'Color',[1 1 1 ]);
clabel(C,h,'Color',[1 1 1],'FontSize',15);
set(gca,'Ydir','reverse');
axis equal;

% do global ROC

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
ROC = genROC([conditionFunc ' ' field 'global ROC'],sigHolder,bkHolder,'doPlot',true);

if params.fitGamma
    %% fit gamma distribution
    h = createMaxFigure([conditionFunc ' pdf background and gamma fit']);
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
        title({['A' num2str(currA) ' B' num2str(currB)],[num2str(phat(1)) ',' num2str(phat(2))]});
        axis tight;
        bkShape(ii) = phat(1);
        bkScale(ii) = phat(2);
    end
    figure;imagesc([minA,maxA],[minB,maxB],bkShape');colorbar;title('bk shape');xlabel('A');ylabel('B');
    figure;imagesc([minA,maxA],[minB,maxB],bkScale');colorbar;title('bk scale');xlabel('A');ylabel('B');
    figure;plot(linspace(minB,maxB,size(bkScale,2)),bkScale(1,:));title(['bkscale w psfSize' mat2str(size(benchStruct.psfs{1}))]);
    
    %% fit gamma distribution
    h = createMaxFigure([conditionFunc ' pdf signal ']);
    sigShape = zeros(sizeAB);
    sigScale = zeros(sizeAB);
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
        title({['A' num2str(currA) ' B' num2str(currB)],[num2str(phat(1)) ',' num2str(phat(2))]});
        axis tight;
        sigShape(ii) = phat(1);
        sigScale(ii) = phat(2);
    end
    figure;imagesc([minA,maxA],[minB,maxB],sigShape');colorbar;title('sig shape');xlabel('A');ylabel('B');
    figure;imagesc([minA,maxA],[minB,maxB],sigScale');colorbar;title('sig scale');xlabel('A');ylabel('B');
    
end
