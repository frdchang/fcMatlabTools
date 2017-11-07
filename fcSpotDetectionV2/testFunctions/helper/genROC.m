function datas = genROC(nameOfMeasure,withTarget,withoutTarget,varargin)
%GENROC will generate a ROC curve and histogram

%--parameters--------------------------------------------------------------
params.doPlot     = false;
params.NumBinsMAX = 2000;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


Nsamples = 10000;
titleText = [nameOfMeasure ' as Measure'];
xLabelText = [nameOfMeasure ' Value'];
yLabelText = 'pdf';
% plot pdfs
if params.doPlot
    grandf = figure;
else
    grandf = figure('Visible','off');
end
hold on;
[h1,h2] = histSigBkgnd(withTarget,withoutTarget);
h1.Normalization = 'pdf';
h2.Normalization = 'pdf';
% h1 = histogram(withTarget,'Normalization','pdf');
% h2 = histogram(withoutTarget,'Normalization','pdf');
% h1.BinWidth = max(h1.BinWidth,h2.BinWidth);
% h2.BinWidth = max(h1.BinWidth,h2.BinWidth);
% minEdge = min(min(h1.BinEdges),min(h2.BinEdges));
% maxEdge = max(max(h1.BinEdges),max(h2.BinEdges));
% binWidth = h1.BinWidth;
% h1.BinEdges = minEdge:binWidth:maxEdge;
% h2.BinEdges = minEdge:binWidth:maxEdge;
title([titleText ' (N=' num2str(numel(withTarget)) ')']);
xlabel(xLabelText);
ylabel(yLabelText);
set(gca,'Color',[1 1 1]);
set(gcf,'Color',[1 1 1]);
legend('bkgnd','signal');
% set(gca,'Yscale','log');
h1.EdgeColor = 'none';
h2.EdgeColor = 'none';
if h1.NumBins > params.NumBinsMAX
    h1.NumBins = params.NumBinsMAX;
end
if h2.NumBins > params.NumBinsMAX
    h2.NumBins = params.NumBinsMAX;
end

% calculate cdf
binWidthH1 = h1.BinEdges;
binWidthH1(binWidthH1==inf) = [];
if numel(binWidthH1)==1
binWidthH1 = binWidthH1(1);
else
    binWidthH1 = diff(binWidthH1);
    binWidthH1 = binWidthH1(1);
end
binWidthH2 = h2.BinEdges;
binWidthH2(binWidthH2==inf) = [];
if numel(binWidthH2)==1
binWidthH2 = binWidthH2(1);
else
    binWidthH2 = diff(binWidthH2);
    binWidthH2 = binWidthH2(1);
end
withTargetCDF = cumsum(h1.Values*binWidthH1);
withoutTargetCDF = cumsum(h2.Values*binWidthH2);

wCDFold = [0 withTargetCDF];
woCDFold = [0 withoutTargetCDF];
Nsamples = max([Nsamples,numel(wCDFold),numel(woCDFold)]);
h1Edges = h1.BinEdges;
h2Edges = h2.BinEdges;
idxINF1 = find(h1Edges==inf);
idxINF2 = find(h2Edges==inf);
h2Edges(idxINF2) = [];
h1Edges(idxINF1) = [];
wCDFold(idxINF1) = [];
woCDFold(idxINF2) = [];
newDomain = linspace(min([h1Edges h2Edges]),max([h1Edges+1, h2Edges+1]),Nsamples);

if numel(h1Edges) == 1
    wCDF = newDomain > h1Edges;
else
    wCDF = interp1(h1Edges,wCDFold,newDomain,'pchip');

end
woCDF = interp1(h2Edges,woCDFold,newDomain,'pchip');



woCDF(newDomain<min([h2Edges])) = 0;
woCDF(newDomain>max([h2Edges])) = 1;
wCDF(newDomain<min([h1Edges])) = 0;
wCDF(newDomain>max([h1Edges])) = 1;
if params.doPlot
    cdfH=figure;plot(newDomain,woCDF,'LineWidth',1.5);hold on;plot(newDomain,wCDF,'LineWidth',1.5);legend('wo','w');
    plot(h1Edges,wCDFold,'o');plot(h2Edges,woCDFold,'o');
    title(['CDF: ' titleText]);
    axis tight;
end
% maxSize = max(numel(withTargetCDF),numel(withoutTargetCDF))+1;
% % calculate ROC
% wCDF = ones(maxSize,1);
% woCDF = ones(maxSize,1);
% wCDF(2:numel(withTargetCDF)+1) = withTargetCDF;
% woCDF(2:numel(withoutTargetCDF)+1) = withoutTargetCDF;
% wCDF(1) = 0;
% woCDF(1) =0;
[x0,y0,~,~] = intersections(1-woCDF,1-wCDF,[0,1],[1,0],1);
error = abs(x0 - (1-y0));
idxOfEER = error ==  min(error);
EER = x0(idxOfEER);

if params.doPlot
    ROCh=figure;plot(1-woCDF,1-wCDF,'LineWidth',2); axis equal;axis([0 1 0 1]);
    set(gca,'Color',[1 1 1]);
    set(gcf,'Color',[1 1 1]);
    title(['Reciever Operator Characteristic: ' titleText]);
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    hold on;plot([0,1],[1,0],'--r');
    
    text(EER,1-EER,...
        ['\leftarrow EER ' num2str(EER)],...
        'FontSize',16)
end


datas.withTargetCDF = wCDF;
datas.newDomain = newDomain;
datas.withoutTargetCDF = woCDF;
datas.withTargetPDF = h1.Values;
datas.withTargetBinEdges = h1.BinEdges;
datas.withoutTargetPDF = h2.Values;
datas.withoutTargetBinEdges = h2.BinEdges;
datas.EER  = EER;

% h1.Normalization = 'count';
% h2.Normalization = 'count';

if h1.BinEdges(end) == Inf && h1.Values(end) ~=0
    figure(grandf);
    hold on;text(h1.BinEdges(end-1),h1.Values(end),'Infinity');
end

if h2.BinEdges(end) == Inf && h2.Values(end) ~=0
    figure(grandf);
    hold on;text(h2.BinEdges(end-1),h2.Values(end),'Infinity');
end

if params.doPlot
    datas.histHandle = grandf;
    datas.ROCHandle = ROCh;
    datas.CDFHandle = cdfH;
else
    close(grandf);
end
end

