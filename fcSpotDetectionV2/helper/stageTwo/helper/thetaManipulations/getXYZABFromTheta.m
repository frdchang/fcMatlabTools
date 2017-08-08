function [ cellofSpotCoorsNonFlattened ] = getXYZABFromTheta( theta0 )
%GETXYZABFROMTHETA Summary of this function goes here
%   Detailed explanation goes here

theta0 = theta0(2:end);
cellofSpotCoorsNonFlattened = cellfunNonUniformOutput(@getCoors,theta0);
cellOfBkgndsNonFlattened = cellfunNonUniformOutput(@getBkgnds,theta0);

for ii = 1:numel(cellofSpotCoorsNonFlattened)
    if ~isempty( cellofSpotCoorsNonFlattened{ii})
        cellofSpotCoorsNonFlattened{ii} = cellfunNonUniformOutput(@(x)[x cellOfBkgndsNonFlattened{ii}{1}],cellofSpotCoorsNonFlattened{ii});
    end
end

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

function bkgnds = getBkgnds(indtheta)
bkgnds = {};
for ii = 1:numel(indtheta)
    currShape = indtheta{ii};
    if isempty(regexp(class(currShape{1}),'myPattern','ONCE'))
        bkgnds{end+1} = currShape{1};
    end
end
end