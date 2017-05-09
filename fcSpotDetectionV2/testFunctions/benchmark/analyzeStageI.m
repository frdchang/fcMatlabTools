function [h] = analyzeStageI(processStruct)

%ANALYZESTAGEI will analyze the stageI output
myAxis = [0.1 1000000 0.01 0.1];
conditions = processStruct.conditions;
sizeAB = size(conditions);
h = createMaxFigure;
for ii = 1:prod(sizeAB)
    display(ii);
    currConditions = conditions{ii};
    subplot_tight(sizeAB(1),sizeAB(2),ii);
    hBk  = histogram(currConditions.bkLL);
    hBk.Normalization = 'probability';
    hold on;
    hSig = histogram(currConditions.sigLL);
    hSig.Normalization = 'probability';
    hBk.EdgeColor = 'none';
    hSig.EdgeColor = 'none';
    title(['A' num2str(currConditions.A) ' B' num2str(currConditions.B)]);
    set(gca,'XScale','log');
    set(gca,'YScale','log');
    axis(myAxis);
end
legend('bk','sig');


