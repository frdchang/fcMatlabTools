function [ theta0 ] = correctThetaForBBox( theta0,BBox )
%CORRECTTHETAFORBBOX Summary of this function goes here
%   Detailed explanation goes here


theta0(2:end) = cellfunNonUniformOutput(@(x) updateCoors(x,BBox),theta0(2:end));

end

function indtheta = updateCoors(indtheta,BBox)
numDimBBox = numel(BBox)/2;
correctionFactor = BBox(1:numDimBBox)-1;
correctionFactor= flipXYCoors(correctionFactor)';
for ii = 1:numel(indtheta)
    if ~isempty(regexp(class(indtheta{ii}{1}),'myPattern','ONCE'))
        indtheta{ii}{2}(2:2+numDimBBox-1) = indtheta{ii}{2}(2:2+numDimBBox-1) - correctionFactor; 
    end
end
end