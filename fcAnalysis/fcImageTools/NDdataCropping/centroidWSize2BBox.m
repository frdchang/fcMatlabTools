function BBox = centroidWSize2BBox(centroid,BBoxSize)
%CENTROIDWSIZE2BBOX converts centroid and BBoxSize to BBox.  note this
%function does not curate the BBox to fit your given dataset.

numDims = numel(centroid);
if ~isequal(numDims,numel(BBoxSize))
   error('centroid dimension does not match BBoxSize dimension'); 
end

BBox = zeros(2*numDims,1);
for i = 1:numDims
    BBox(i) = centroid(i) - floor(BBoxSize(i)/2);
    BBox(i+numDims) = BBoxSize(i);
end


end

