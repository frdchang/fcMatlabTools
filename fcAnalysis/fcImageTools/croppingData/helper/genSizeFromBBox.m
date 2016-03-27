function sizeData = genSizeFromBBox(BBox)
%GENSIZEFROMBBOX generates size from BBox
%
% fchang@fas.harvard.edu

sizeData = BBox(numel(BBox)/2+1:end);
indices = 1:numel(sizeData);
indices(2) = 1;
indices(1) = 2;
sizeData = round(sizeData(indices));
end

