function firstNonEmptyContent = getFirstNonEmptyCellContent(cellArray)
%GETFIRSTNONEMPTYCELLCONCENT will return the first non empty content in the
% cell array

firstNonEmptyIndex = find(cellfun(@isempty,cellArray)==0,1,'first');

if isempty(firstNonEmptyIndex)
    firstNonEmptyContent = [];
    return;
end
firstNonEmptyContent = cellArray{firstNonEmptyIndex};

end

