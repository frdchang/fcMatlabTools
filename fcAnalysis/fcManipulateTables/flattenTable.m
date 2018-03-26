function [ cellOfElements ] = flattenTable( myTable )
%FLATTENTABLE will take a table and return all the elements in it

myrows = myTable.Properties.VariableNames;
cellOfElements = cell(numel(myrows),1);
for ii = 1:numel(myrows)
   currRow = myTable.(myrows{ii}); 
   cellOfElements{ii} = currRow;
end
cellOfElements = flattenCellArray(cellOfElements);

end

