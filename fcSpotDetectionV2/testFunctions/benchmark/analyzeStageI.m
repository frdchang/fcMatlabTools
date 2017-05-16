function [h,conditionHolder] = analyzeStageI(benchStruct,conditionFunc,field)

conditionFunc = func2str(conditionFunc);
%ANALYZESTAGEI will analyze the stageI output
myAxis = [0.1 1000000 0.01 1];
conditions = benchStruct.(conditionFunc);
sizeAB = [size(conditions,1) size(conditions,2)];
idxConditions = zeros(size(conditions));
idxConditions(:,:,1) = 1;
conditions = conditions(logical(idxConditions));

h = createMaxFigure(conditionFunc);
conditionHolder = cell(size(conditions));
minAxis = inf;
maxAxis = -inf;
for ii = 1:prod(sizeAB)
    display(ii);
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
    
    subplot(sizeAB(1),sizeAB(2),ii);
    hBk  = histogram(bk);
    hBk.Normalization = 'cdf';
    hold on;
    hSig = histogram(sig);
    hSig.Normalization = 'cdf';
    hBk.EdgeColor = 'none';
    hSig.EdgeColor = 'none';
    currMin = min([hSig.BinEdges hBk.BinEdges]);
    currMax = max([hSig.BinEdges hBk.BinEdges]);
    if currMin < minAxis
        minAxis = currMin;
    end
    if currMax > maxAxis
        maxAxis = currMax;
    end
    title(['A' num2str(currA) ' B' num2str(currB)]);

%     set(gca,'XScale','log');
    %     set(gca,'YScale','log');
end
legend('bk','sig');

for ii = 1:prod(sizeAB)
    hold on;subplot(sizeAB(1),sizeAB(2),ii);
    axis([minAxis maxAxis 0 1]);
    if minAxis <0 || maxAxis < 0
        
    else
            set(gca,'XScale','log');

    end
end


