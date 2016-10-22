function cellBasedOrdering = convert2CellBasedOrdering(varargin)
%CONVERT2CELLBASEDORDERING converts the output from extract cell to be cell
%centric so applyfunc can operate cell based operations in parallel



arguments = cellfunNonUniformOutput(@(x) x.outputFiles,varargin);
numTimeLapses = numel(arguments{1});
cellBasedOrdering = {};
for ii = 1:numTimeLapses
   cellsForCurrTimeLapse = cellfunNonUniformOutput(@(x) x{ii},arguments);
   numCellsForCurrTimeLapse = size(cellsForCurrTimeLapse{1},2);
   for jj = 1:numCellsForCurrTimeLapse
       cellBasedOrdering{end+1} = cellfunNonUniformOutput(@(x) x(:,jj),cellsForCurrTimeLapse);
   end
end
end

