function [ numSpots ] = numSpotsInTheta( theta )
%NUMSPOTSINTHETA Summary of this function goes here
%   Detailed explanation goes here
theta = theta(2:end);

numSpots = cellfun(@countSpots,theta);
numSpots = sum(numSpots);
end

function numSpots = countSpots(indtheta)
numSpots = 0;
for ii = 1:numel(indtheta)
    currShape = indtheta{ii};
    if ~isempty(regexp(class(currShape{1}),'myPattern','ONCE'))
        numSpots = numSpots + 1;
    end
end
end