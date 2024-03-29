function [ cellofSpotCoors,cellofSpotCoorsNonFlattened,idxSpots] = getSpotCoorsFromTheta( theta0 )
%GETSPOTCOORSFROMTHETA return the spot coors of theta0 and returns a cell
%array of them

theta0 = theta0(2:end);

cellofSpotCoorsNonFlattened = cellfunNonUniformOutput(@getCoors,theta0);
idxSpots = ~cellfun(@isempty,cellofSpotCoorsNonFlattened);

cellofSpotCoors = flattenCellArray(cellofSpotCoorsNonFlattened);

end

function coors = getCoors(indtheta)
coors = {};
for ii = 1:numel(indtheta)
    currShape = indtheta{ii};
    if ~isempty(regexp(class(currShape{1}),'myPattern','ONCE'))
        coors{end+1} = currShape{2}(2:end);
    end
end
end



