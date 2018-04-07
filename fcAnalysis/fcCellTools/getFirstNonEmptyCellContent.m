function firstNonEmptyContent = getFirstNonEmptyCellContent(cellArray)
%GETFIRSTNONEMPTYCELLCONCENT will return the first non empty content in the
% cell array
firstNonEmptyIndex = getFirstNonEmptyCellContent(cellArray);
if isempty(firstNonEmptyIndex)
    firstNonEmptyContent = [];
    return;
end
firstNonEmptyContent = cellArray{firstNonEmptyIndex};

end

