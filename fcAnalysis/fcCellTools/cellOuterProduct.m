function [ output ] = cellOuterProduct( cellVector )
%CELLOUTERPRODUCT calculates the outerproduct of a vector of cells

numEl = numel(cellVector);
[x_i,y_i] = meshgrid(1:numEl,1:numEl);
output = cell(numEl,numEl);

for ii = 1:numel(x_i)
   output{ii} = cellVector{x_i(ii)}.*cellVector{y_i(ii)}; 
end

end

