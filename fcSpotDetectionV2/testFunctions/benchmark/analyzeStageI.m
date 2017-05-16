function [h,conditionHolder] = analyzeStageI(benchStruct,conditionFunc,field)
% first plots cdf
% then it plots overlap percentage
% then it plots global ROC for A>=B

conditionFunc = func2str(conditionFunc);
%ANALYZESTAGEI will analyze the stageI output
myMin = 0.1;
conditions = benchStruct.(conditionFunc);
sizeAB = [size(conditions,1) size(conditions,2)];
idxConditions = zeros(size(conditions));
idxConditions(:,:,1) = 1;
conditions = conditions(logical(idxConditions));

h = createMaxFigure(conditionFunc);
conditionHolder = cell(size(conditions));
currMin = inf;
currMax = -inf;
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


for ii = 1:prod(sizeAB)
    currA = conditions{ii}.A;
    currB = conditions{ii}.B;
    sig = conditionHolder{ii}.sig + currMin + myMin;
    bk = conditionHolder{ii}.bk+ currMin + myMin;
    subplot(sizeAB(1),sizeAB(2),ii);
    hBk  = histogram(bk);
    hBk.Normalization = 'cdf';
    hold on;
    hSig = histogram(sig);
    hSig.Normalization = 'cdf';
    hBk.EdgeColor = 'none';
    hSig.EdgeColor = 'none';
    title(['A' num2str(currA) ' B' num2str(currB)]);
end
legend('bk','sig');

for ii = 1:prod(sizeAB)
    hold on;subplot(sizeAB(1),sizeAB(2),ii);
    axis([myMin 10^ceil(log10(currMax)) 0 1]);
    set(gca,'XScale','log');
end


