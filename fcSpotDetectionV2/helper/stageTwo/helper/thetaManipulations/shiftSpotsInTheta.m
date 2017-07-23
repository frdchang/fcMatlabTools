function [ theta ] = shiftSpotsInTheta( theta,shiftFactor )
%SHIFTSPOTSINTHETA Summary of this function goes here
%   Detailed explanation goes here

theta(2:end) = cellfunNonUniformOutput(@(x) shiftSpots(x,shiftFactor),theta(2:end));
end

function indtheta = shiftSpots(indtheta,shiftFactor)

for ii = 1:numel(indtheta)
    if ~isempty(regexp(class(indtheta{ii}{1}),'myPattern','ONCE'))
        indtheta{ii}{2}(1:numel(shiftFactor)) = indtheta{ii}{2}(1:numel(shiftFactor)) + shiftFactor;
    end
end
end

