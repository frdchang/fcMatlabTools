function maxBBoxForEachCell = findMaxBBoxForSeq(Lseq,cellAreaseq)
%FINDMAXBBOXFORSEQ Summary of this function goes here
%   Detailed explanation goes here
[~,indexOfMaxArea] = max(cellAreaseq,[],2);
% find bounding box of max area for each cell
numCells = max(Lseq(:));
maxBBoxForEachCell = cell(numCells,1);
for ii = 1:numCells
    getTimeIndexOfMaxSize = indexOfMaxArea(ii);
    segmenationOfMaxSize = Lseq(:,:,getTimeIndexOfMaxSize);
    stats = regionprops(bwconvhull(segmenationOfMaxSize==ii));
    if ~isempty(stats)
    maxBBoxForEachCell{ii} = genSizeFromBBox(stats.BoundingBox);
    else
        maxBBoxForEachCell{ii} = [];
    end
end


end

