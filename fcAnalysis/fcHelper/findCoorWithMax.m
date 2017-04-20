function [ coors ] = findCoorWithMax(ndData)
%FINDCOORWITHMAX will return the coordinate with the maximum value

idx = find(ndData==max(ndData(:)));
coors= ind2subND(size(ndData),idx);


end

