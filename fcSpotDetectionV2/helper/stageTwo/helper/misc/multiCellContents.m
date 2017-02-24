function [ multiArrays ] = multiCellContents( cellsOfArrays )
%MULTICELLCONTENTS Summary of this function goes here
%   Detailed explanation goes here

multiArrays = 0;

for ii = 1:numel(cellsOfArrays)
   multiArrays = multiArrays .* cellsOfArrays{ii}; 
end


end

