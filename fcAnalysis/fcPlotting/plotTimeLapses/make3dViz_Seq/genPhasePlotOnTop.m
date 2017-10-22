function phasePlotOnTop = genPhasePlotOnTop(phasePaths,numSeq)
%GENPHASEPLOTONTOP see how many phase images you can fit on numSeq

aPhaseImg = importStack(getFirstNonEmptyCellContent(phasePaths));
sizeData = size(aPhaseImg);

numberOfPhaseImgs = numSeq / sizeData(2);

phasePlateOnTop = zeros(sizeData(1),numSeq);
for ii = 1:sizeData(2):floor(numberOfPhaseImgs)
    
end

