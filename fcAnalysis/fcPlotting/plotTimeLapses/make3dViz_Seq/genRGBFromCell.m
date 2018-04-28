function [ rgb ] = genRGBFromCell( cellOfDatas )
%GENRGBFROMCELL given a cell of data it will combine them to be an rgb img

rgb = ncellfun(@(x) zeros(size(x,1),size(x,2),3),cellOfDatas{1});

for ii = 1:numel(rgb)
   for jj = 1:numel(cellOfDatas)
      rgb{ii}(:,:,jj) = cellOfDatas{jj}{ii}; 
   end
end

for ii = 1:numel(rgb)
    rgb{ii}(:,:,[2 1]) = rgb{ii}(:,:,[1 2]);
end
rgb = ncellfun(@norm2UINT255,rgb);


