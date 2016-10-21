function glued = glueCellArguments(varargin)
%GLUECELLARRAYS will glue cell arrays together that have the same structure

numArguments = numel(varargin);

numElements = numel(varargin{1});
glued = cell(numElements,1);

for ii = 1:numElements
    glued{ii} = cellfunNonUniformOutput(@(x) x{ii}{:},varargin);
end


end

