function [filteredBW] = filterBWbySizeRange(bwData,minSize,maxSize)
%FILTERBWBYSIZERANGE selects connected objects in bwData by minRange
%maxRange size

CC = bwconncomp(bwData);
s = regionprops(bwData,'Area');
L = labelmatrix(CC);
filteredBW = ismember(L, find([s.Area] <= maxSize & [s.Area] >= minSize));
end

