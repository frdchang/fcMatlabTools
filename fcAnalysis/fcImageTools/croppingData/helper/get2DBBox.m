function BBox2D = get2DBBox(BBox)
%GET2DBBOX converts an nd BBox to a 2D version

numDims = numel(BBox)/2;
BBox2D = zeros(4,1);
BBox2D([1,3]) = BBox([1,1+numDims]);
BBox2D([2,4]) = BBox([2,2+numDims]);


end

