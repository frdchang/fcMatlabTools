function [ output ] = extractCellStructField(cellOfStructArray,structIndex,field)
%EXTRACTCELLSTRUCTFIELD given a cell of struct arrays
%{structArray1,structArray2,...}
% it will extract given the index of the struct array and the field
% and output 

output = cell(size(cellOfStructArray));

for ii = 1:numel(output)
    currStruct = cellOfStructArray{ii};
    if numel(currStruct) >= structIndex
       output{ii} = currStruct(structIndex).(field); 
    end
    
end


end

