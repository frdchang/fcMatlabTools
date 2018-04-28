function [seedMask] = findMaxInRegions(data,bwMask)
%FINDMAXINREGIONS for each region find the maximum pixel and return as seed
%mask
stats = regionprops(bwMask>0,data,'MaxIntensity','PixelIdxList');
seedMask = zeros(size(data));

for ii = 1:numel(stats)
   coor = stats(ii).PixelIdxList(data(stats(ii).PixelIdxList) == stats(ii).MaxIntensity);
   seedMask(coor) =1;
end
end

