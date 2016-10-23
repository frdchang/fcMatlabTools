function firstNonEmptyContent = getFirstNonEmptyCellContent(cellArray)
%GETFIRSTNONEMPTYCELLCONCENT will return the first non empty content in the
% cell array

firstNonEmptyIndex = find(cellfun(@isempty,cellArray)==0,1,'first');

firstNonEmptyContent = cellArray{firstNonEmptyIndex};

end

