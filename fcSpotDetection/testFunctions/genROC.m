function datas = genROC(nameOfMeasure,withTarget,withoutTarget)
%GENROC will generate a ROC curve and histogram

titleText = [nameOfMeasure ' as Measure'];
xLabelText = [nameOfMeasure ' Value'];
yLabelText = 'pdf';
% plot pdfs
figure;
h1 = histogram(withTarget,'Normalization','pdf'); hold on;
h2 = histogram(withoutTarget,'Normalization','pdf');
h1.BinWidth = max(h1.BinWidth,h2.BinWidth);
h2.BinWidth = max(h1.BinWidth,h2.BinWidth);
minEdge = min(min(h1.BinEdges),min(h2.BinEdges));
maxEdge = max(max(h1.BinEdges),max(h2.BinEdges));
binWidth = h1.BinWidth;
h1.BinEdges = minEdge:binWidth:maxEdge;
h2.BinEdges = minEdge:binWidth:maxEdge;
title([titleText ' (N=' num2str(numel(withTarget)) ')']);
xlabel(xLabelText);
ylabel(yLabelText);
set(gca,'Color',[1 1 1]);
set(gcf,'Color',[1 1 1]);
legend('with spot','without spot');

% calculate cdf
withTargetCDF = cumsum(h1.Values*h1.BinWidth);
withoutTargetCDF = cumsum(h2.Values*h2.BinWidth);
maxSize = max(numel(withTargetCDF),numel(withoutTargetCDF))+1;
% calculate ROC
wCDF = ones(maxSize,1);
woCDF = ones(maxSize,1);
wCDF(2:numel(withTargetCDF)+1) = withTargetCDF;
woCDF(2:numel(withoutTargetCDF)+1) = withoutTargetCDF;
wCDF(1) = 0;
woCDF(1) =0;
figure;plot(1-woCDF,1-wCDF,'LineWidth',2); axis equal;axis([0 1 0 1]);
set(gca,'Color',[1 1 1]);
set(gcf,'Color',[1 1 1]);
title(['Reciever Operator Characteristic: ' titleText]);
xlabel('False Positive Rate');
ylabel('True Positive Rate');
datas.withTargetCDF = wCDF;
datas.withoutTargetCDF = woCDF;
datas.withTargetPDF = h1.Values;
datas.withTargetBinEdges = h1.BinEdges;
datas.withoutTargetPDF = h2.Values;
datas.withoutTargetBinEdges = h2.BinEdges;
end

