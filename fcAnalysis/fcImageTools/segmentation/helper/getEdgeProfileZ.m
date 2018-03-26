function [ edgeProfileZ ] = getEdgeProfileZ( brightZstack )
%GETEDGEPROFILEZ Summary of this function goes here
%   Detailed explanation goes here

[x,y] = getline_zoom(maxintensityproj(brightZstack,3));
% average all the points to get one edgeProfile
edgeProfileZ = zeros(numel(x),size(brightZstack,3));
for i = 1:numel(x)
    currProfile = brightZstack(round(y(i)),round(x(i)),:);
    edgeProfileZ(i,:) = currProfile(:);
end
edgeProfileZ = mean(edgeProfileZ);
display(['''edgeProfileZ'', ' mat2str(edgeProfileZ)]);
end

