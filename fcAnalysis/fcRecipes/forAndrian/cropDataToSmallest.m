function [centerCropped] = cropDataToSmallest(dataCell,cropSize)
%CROPDATATOSMALLEST Summary of this function goes here
%   Detailed explanation goes here

% smallest = min(cell2mat(cellfunNonUniformOutput(@(x) size(x,1),dataCell)));
smallest = cropSize;
centerCropped = cell(numel(dataCell,1));

for ii = 1:numel(dataCell)
    display(ii)
    currData = dataCell{ii};
    lengthData = numel(currData);
    startVal = floor((lengthData-smallest)/2)+1;
    endVal   = startVal + smallest-1;
    centerCropped{ii} = currData(startVal:endVal);
end



