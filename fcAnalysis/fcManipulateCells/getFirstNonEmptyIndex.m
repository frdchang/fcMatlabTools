function [ firstNonEmptyIndex ] = getFirstNonEmptyIndex( cellArray )
%GETFIRSTNONEMPTYINDEX Summary of this function goes here
%   Detailed explanation goes here
cellArray = cellfunNonUniformOutput(@flattenCellArray,cellArray);
firstNonEmptyIndex = find(cellfun(@isempty,cellArray)==0,1,'first');

end

