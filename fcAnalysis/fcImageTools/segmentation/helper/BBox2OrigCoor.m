function origCoor = BBox2OrigCoor(BBox,BBoxCoor)
%BBOX2ORIGCOOR will take a coordinate in BBox space, BBoxCoor and give back
%the origCoor given BBox

cornerCoor = BBox(1:numel(BBox)/2);

origCoor = cornerCoor(:) + BBoxCoor(:);
origCoor(1:2) = origCoor(2:-1:1);
end

