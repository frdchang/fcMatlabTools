function [ cellofSpotCoorsNonFlattened ] = getXYZAFromTheta( theta0 )
%GETXYZABFROMTHETA Summary of this function goes here
%   Detailed explanation goes here

theta0 = theta0(2:end);
cellofSpotCoorsNonFlattened = cellfunNonUniformOutput(@getCoors,theta0);

end

function coors = getCoors(indtheta)
coors = {};
for ii = 1:numel(indtheta)
    currShape = indtheta{ii};
    if ~isempty(regexp(class(currShape{1}),'myPattern','ONCE'))
        coors{end+1} = [currShape{2}(2:end) currShape{2}(1)];
    end
end
end