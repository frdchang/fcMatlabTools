function [ lastNonEmptyIndex ] = getLastNonEmptyIndex( cellArray )
%GETLASTNONEMPTYINDEX Summary of this function goes here
%   Detailed explanation goes here
cellArray = cellfunNonUniformOutput(@flattenCellArray,cellArray);
lastNonEmptyIndex = find(cellfun(@isempty,cellArray)==0,1,'last');

end

