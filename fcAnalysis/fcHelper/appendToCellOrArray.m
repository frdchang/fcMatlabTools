function [ origCellOrArray ] = appendToCellOrArray(origCellOrArray,appendCellOrArray)
%APPENDTOCELLORARRAY will do the operation of appending the cell or array
%to original.

numAppend = numel(appendCellOrArray);

origCellOrArray(end+1:end+numAppend) = appendCellOrArray(:);


end

