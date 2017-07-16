function glued = glueCellArguments(varargin)
%GLUECELLARRAYS will glue cell arrays together that have the same structure

numArguments = numel(varargin);



% extrude the elements to longest 
numElements = max(cellfun(@numel,varargin));
glued = cell(numElements,1);

for ii = 1:numArguments
   varargin{ii}(end:numElements) = varargin{ii}(end); 
end


for ii = 1:numElements
    glued{ii} = cellfunNonUniformOutput(@(x) x{ii}{:},varargin);
end


end

