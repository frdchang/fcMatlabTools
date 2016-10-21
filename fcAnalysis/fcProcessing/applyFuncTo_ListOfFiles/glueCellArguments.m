function glued = glueCellArguments(cellArray1,cellArray2)
%GLUECELLARRAYS will glue cell arrays together that have the same structure

numElements = numel(cellArray1);
glued = cell(numElements,1);

for ii = 1:numElements
    glued{ii} = {cellArray1{ii}{:},cellArray2{ii}{:}}; 
end


end

