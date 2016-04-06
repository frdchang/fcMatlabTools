function emptyIdx = findEmptyCells(myCell)
%FINDEMPTYCELLS will find the empty indices of myCell array.

emptyIdx = cellfun(@isempty,myCell);


end

