function [h,conditionHolder] = analyzeStageI(benchStruct)

conditionFunc = 'findSpotsStage1V2';
field = 'LLRatio';
%ANALYZESTAGEI will analyze the stageI output
myAxis = [0.1 1000000 0.01 1];
conditions = benchStruct.findSpotsStage1V2;
sizeAB = [size(conditions,1) size(conditions,2)];
idxConditions = zeros(size(conditions));
idxConditions(:,:,1) = 1;
conditions = conditions(logical(idxConditions));

h = createMaxFigure;
conditionHolder = cell(size(conditions));
for ii = 1:prod(sizeAB)
    display(ii);
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    currD = conditions{ii}.D
    currFuncConditions = conditions{ii}.(conditionFunc);
    %% extract the signal and bkgnd
    sig = zeros(numel(currFuncConditions),1);
    bk  = cell(numel(currFuncConditions),1); 
    for jj = 1:numel(currFuncConditions)
       currFuncOutput = load(currFuncConditions{jj}); 
       currFuncOutput=  currFuncOutput.x;
       currFuncOutput = currFuncOutput.(field);
       [sig(jj),bk{jj}] = measureSigBkgnd(currFuncOutput,benchStruct.centerCoor,size(benchStruct.psfs{1}));
    end
    bk = cell2mat(bk);
    conditionHolder{ii}.sig = sig;
    conditionHolder{ii}.bk  = bk;
    
    subplot_tight(sizeAB(1),sizeAB(2),ii);
    hBk  = histogram(bk);
    hBk.Normalization = 'cdf';
    hold on;
    hSig = histogram(sig);
    hSig.Normalization = 'cdf';
    hBk.EdgeColor = 'none';
    hSig.EdgeColor = 'none';
    title(['A' num2str(currA) ' B' num2str(currB)]);
     set(gca,'XScale','log');
%     set(gca,'YScale','log');
     axis(myAxis);
end
legend('bk','sig');


