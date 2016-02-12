function [subImg] = getSubsetwBBoxND(varargin)
%GETSUBSET carve out a subset of an nDOjbect with carveSpace
% carveSpace = [x0,y0,...,xLength,yLength,...]
% note image tools in matlab map x coordinates into the row space (across
% the screen) and y coordinates into column space (down the screen), so
% i will flip the first two dimensions.
%
% -this function will extrude into the remaining dimensions
% -this function will check for nDObject boundaries
% -this function can also add a boundingbox + frame
%  e.g. getNdSubset(data,boundingBox,[10,1]); frame added to bounding box
%  is [10] in first dimension and [1] in next.  dimension of frame should
%  match the dimension of boundingBox
%
% getSubSetwBBoxND(data,BBox) or getSubSetwBBoxND(data,BBox,frame)
%
% fchang@fas.harvard.edu

dataND = varargin{1};
boundingBox = varargin{2};
switch (nargin)
    case 2
        frame = zeros(length(boundingBox)/2,1);
    case 3
        frame = varargin{3};
    otherwise
end
carveSpace = boundingBox;
carveSpace([1,2]) = carveSpace([2,1]);


carveSpace = round(carveSpace);
numDims = ndims(dataND);
numDimsBox = length(carveSpace)/2;
coorDomains = cell(numDims,1);

% convert carveSpace coors into nD matrix coors and populate coorDomains
% argument
for i = 1:numDims
    if i <= numDimsBox
        lowerLimit = max(carveSpace(i)-frame(i),1);
        upperLimit = min(carveSpace(i)+carveSpace(i+ numDimsBox)-1+frame(i),size(dataND,i));
        coorDomains{i} = lowerLimit:upperLimit;
    else
        coorDomains{i} = 1:size(dataND,i);
    end
end

% carveout nD matrix with coorDomains
subImg = dataND(coorDomains{:});

end

