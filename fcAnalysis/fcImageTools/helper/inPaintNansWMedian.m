function [ NDData ] = inPaintNansWMedian(NDData)
%INPAINTNANSWMEDIAN this function will take the dataset with nan pixels and
%inpaint them with the median of its neighboring pixels 

isnanIDX = isnan(NDData);
% expand by single pixel
se = cell(ndims(NDData),1);
[se{:}] = deal(3);
se = ones(se{:});
L = bwlabel(isnanIDX);
for ii = 1:max(L(:))
    currNAN = L==ii;
    neighbors = imdilate(currNAN,se);
    neighbors(currNAN) = 0;
    medianVal = median(NDData(neighbors));
    NDData(currNAN) = medianVal;
end



