function spotted = genSpotsFromCentroids(dataSize,stats)
%GENSPOTSFROMCENTROIDS given a list of centroids, this function will
%generate a mask with the rounded centroids as white.

numDims = numel(dataSize);
spotted = zeros(dataSize,'logical');

centroids = reshape(round([stats.Centroid]),numDims,numel(stats))';
centroids = num2cell(centroids,1);
centroids([1 2]) = centroids([2 1]);
idx = sub2ind(dataSize,centroids{:});
spotted(idx) = 1;
end

