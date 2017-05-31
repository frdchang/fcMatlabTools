function [ centeredPSF ] = centerGenPSF( psfData )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
brightestCoor = findCoorWithMax(psfData);

[centeredPSF,~] = getSubsetwCentroidANdBBoxSizeND(psfData,cell2mat(brightestCoor),size(psfData));

goodPart = ind2subND(size(centeredPSF),find(centeredPSF~=-inf));
goodPart = calcMinMaxFromMeshData(goodPart);
selector = cell(ndims(psfData),1);
for ii = 1:ndims(psfData)
   selector{ii} = goodPart(ii,1):(goodPart(ii,2)-goodPart(ii,1)+1);
end
centeredPSF = centeredPSF(selector{:});
centeredPSF(centeredPSF == -inf) = 0;
% minDim = ones(ndims(psfData));
% maxDim = size(psfData);
%
% leftDist = abs(brightestCoor-minDim);
% rightDist = abs(brightestCoor-maxDim);
%
% cropDists = min([leftDist;rightDist]);

end

