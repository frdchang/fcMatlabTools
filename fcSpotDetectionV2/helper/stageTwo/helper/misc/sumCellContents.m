function summedArrays = sumCellContents(cellsOfArrays)
%SUMCELLCONTENTS will go through cell contents that should be numeric
%arrays and sum them.

summedArrays = 0;

for ii = 1:numel(cellsOfArrays)
   summedArrays = summedArrays + cellsOfArrays{ii}; 
end


end

