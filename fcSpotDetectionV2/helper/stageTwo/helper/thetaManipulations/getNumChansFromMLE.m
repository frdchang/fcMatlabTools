function [ numChans ] = getNumChansFromMLE( spotMLEs )
%GETNUMCHANSFROMMLE Summary of this function goes here
%   Detailed explanation goes here

numChans = getFirstNonEmptyCellContent(spotMLEs);
if isempty(numChans)
    numChans = [];
    return;
end
if isstruct(numChans)
    numChans = numel(numChans(1).theta0s) - 1;

else
    numChans = numel(numChans{1}(1).theta0s) - 1;

end


