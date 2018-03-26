function masked = maskDataND(dataND,mask)
%MASKDATAND will mask ND data, if mask dimension is less than dataND, the
%mask is extruded to the rest of the dimensions

minMask = double(mask);
minMask(minMask==0) = -inf;
minMask(minMask==1) = inf;
masked = bsxfun(@min,dataND,minMask);



end

