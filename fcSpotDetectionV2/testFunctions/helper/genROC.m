function datas = genROC(nameOfMeasure,withTarget,withoutTarget,varargin)
%GENROC will generate a ROC curve and histogram

%--parameters--------------------------------------------------------------
params.doPlot     = false;
params.NumBinsMAX       = 2000;
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
legend('with spot','without spot');
set(gca,'Yscale','log');
h1.EdgeColor = 'none';
h2.EdgeColor = 'none';
if h1.NumBins > params.NumBinsMAX
    h1.NumBins = params.NumBinsMAX;
end
if h2.NumBins > params.NumBinsMAX
    h2.NumBins = params.NumBinsMAX;
end

% calculate cdf
binWidthH1 = unique(diff(h1.BinEdges));
binWidthH1(binWidthH1 == inf | binWidthH1 == -inf) = [];
binWidthH1 = binWidthH1(1);
binWidthH2 = unique(diff(h2.BinEdges));
binWidthH2(binWidthH2 == inf | binWidthH2 == -inf) = [];
binWidthH2 = binWidthH2(1);
withTargetCDF = cumsum(h1.Values*binWidthH1);
withoutTargetCDF = cumsum(h2.Values*binWidthH2);

wCDF = [0 withTargetCDF];
woCDF = [0 withoutTargetCDF];
Nsamples = max([Nsamples,numel(wCDF),numel(woCDF)]);
newDomain = linspace(min([h1.BinEdges h2.BinEdges]),max([h1.BinEdges h2.BinEdges]),Nsamples);
wCDF = interp1(h1.BinEdges,wCDF,newDomain,'pchip');
woCDF = interp1(h2.BinEdges,woCDF,newDomain,'pchip');



woCDF(newDomain<min([h2.BinEdges])) = 0;
woCDF(newDomain>max([h2.BinEdges])) = 1;
wCDF(newDomain<min([h1.BinEdges])) = 0;
wCDF(newDomain>max([h1.BinEdges])) = 1;
if params.doPlot
    figure;plot(newDomain,woCDF);hold on;plot(newDomain,wCDF);legend('wo','w');
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
    figure;plot(1-woCDF,1-wCDF,'LineWidth',2); axis equal;axis([0 1 0 1]);
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
datas.withoutTargetCDF = woCDF;
datas.withTargetPDF = h1.Values;
datas.withTargetBinEdges = h1.BinEdges;
datas.withoutTargetPDF = h2.Values;
datas.withoutTargetBinEdges = h2.BinEdges;
datas.EER  = EER;

if params.doPlot
    
else
    close(grandf);
end
end

