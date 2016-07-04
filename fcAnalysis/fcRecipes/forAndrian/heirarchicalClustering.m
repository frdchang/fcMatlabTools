function optimalIndices = heirarchicalClustering(dataCell)
%HEIRARCHICALCLUSTERING Summary of this function goes here
%   Detailed explanation goes here

matCell = cell2mat(dataCell)';
Y = pdist(matCell,'euclidean');
Z = linkage(Y);
%  optimalIndices = optimalleaforder(Z,Y);
[H,T,optimalIndices] = dendrogram(Z);
end

