function chunkSubs = chunkSubOfDataND(sizeData,Nblocks)
%CHUNKSUBOFDATAND subdivides data by Nblocks and linearly indexes them by
%i.  e.g. dataChunk = data(chunkSub{:})
% overlap defines how much each chunk needs to overlap in each dimension
%
% fchang@fas.harvard.edu

numDims = numel(Nblocks);
dimSteps = sizeData./Nblocks;
numBlocks = prod(Nblocks);
chunkSubs = cell(numBlocks,1);
for i = 1:numBlocks
    chunkSub = ind2subND(Nblocks,i);
    for j = 1:numDims
        currStep = chunkSub{j}*dimSteps(j);
        endingIdx = min(currStep,sizeData(j));
        begIdx    = currStep - dimSteps(j) + 1;
        chunkSub{j} = round(begIdx):round(endingIdx);
    end
    chunkSubs{i} = chunkSub;
end



end

