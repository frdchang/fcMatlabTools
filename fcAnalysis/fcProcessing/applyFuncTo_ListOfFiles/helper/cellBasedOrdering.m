function [ celloutputs ] = cellBasedOrdering(ecoutputs )
%CELLBASTEDORDERING Summary of this function goes here
%   Detailed explanation goes here

numTimepoints = size(ecoutputs,1);
numCells      = size(ecoutputs,2);
celloutputs = cell(numCells,1);
for ii = 1:numCells
    celloutputs{ii} = ecoutputs(:,ii);
end
end

