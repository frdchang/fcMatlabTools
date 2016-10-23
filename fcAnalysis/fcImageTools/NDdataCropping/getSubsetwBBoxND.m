function [subImg,newBBox] = getSubsetwBBoxND(ndData,myBBox,varargin)
%EXTRACTBBOXND will extract out the data defined by BBox.  if BBox
% dimension is less than ndData, it will extrude out the rest.  a frame can
% be defined.  if BBox goes outside the data, it will be padded with -inf
% if borderVector dimension is < dimension of data, then it will not frame
% the rest

%--parameters--------------------------------------------------------------
params.borderVector     = [];
params.padValue         = -inf;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
ndData = double(ndData);
BBoxSize = genSizeFromBBox(myBBox);
% update BBoxSize for border vector
if ~isempty(params.borderVector)
    if numel(params.borderVector) > 1
        indices = 1:numel(params.borderVector);
        indices(2) = 1;
        indices(1) = 2;
        params.borderVector = params.borderVector(indices);
    end
    for i = 1:numel(params.borderVector);
        BBoxSize(i) = BBoxSize(i)+ params.borderVector(i);
    end
end
% pad array to account for edge cropping.
paddedNdData = padarray(ndData,BBoxSize,params.padValue);

carveSpace = myBBox;
numDimsBox = length(carveSpace)/2;
% flip dimensions of x and y to follow convention
carveSpace([1,2]) = carveSpace([2,1]);
carveSpace([1+numDimsBox,2+numDimsBox]) = carveSpace([2+numDimsBox,1+numDimsBox]);
carveSpace = round(carveSpace);
numDims = ndims(ndData);

coorDomains = cell(numDims,1);

frame = zeros(numDimsBox,1);
if ~isempty(params.borderVector)
    for i = 1:numel(params.borderVector)
        frame(i) = params.borderVector(i);
    end
end

% convert carveSpace coors into nD matrix coors and populate coorDomains
% argument
newBBox = zeros(numDims*2,1);
for i = 1:numDims
    if i <= numDimsBox
        
        lowerLimit = carveSpace(i) + BBoxSize(i) - frame(i);
        upperLimit = carveSpace(i)+carveSpace(i+ numDimsBox)-1+frame(i) + BBoxSize(i);
        newBBox(i) = lowerLimit - BBoxSize(i);
        newBBox(i+numDims) = upperLimit - lowerLimit;
        coorDomains{i} = lowerLimit:upperLimit;
    else
        coorDomains{i} = 1:size(ndData,i);
        newBBox(i) = 1;
        newBBox(i+numDims) = size(nData,i);
    end
end
newBBox([1,2]) = newBBox([2,1]);
newBBox([1+numDims,2+numDims]) = newBBox([2+numDims,1+numDims]);
% carveout nD matrix with coorDomains
subImg = paddedNdData(coorDomains{:});








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



% 
% dataND = varargin{1};
% boundingBox = varargin{2};
% switch (nargin)
%     case 2
%         frame = zeros(length(boundingBox)/2,1);
%     case 3
%         frame = varargin{3};
%     otherwise
% end
% carveSpace = boundingBox;
% carveSpace([1,2]) = carveSpace([2,1]);
% 
% 
% carveSpace = round(carveSpace);
% numDims = ndims(dataND);
% numDimsBox = length(carveSpace)/2;
% coorDomains = cell(numDims,1);
% 
% % convert carveSpace coors into nD matrix coors and populate coorDomains
% % argument
% for i = 1:numDims
%     if i <= numDimsBox
%         lowerLimit = max(carveSpace(i)-frame(i),1);
%         upperLimit = min(carveSpace(i)+carveSpace(i+ numDimsBox)-1+frame(i),size(dataND,i));
%         coorDomains{i} = lowerLimit:upperLimit;
%     else
%         coorDomains{i} = 1:size(dataND,i);
%     end
% end
% 
% % carveout nD matrix with coorDomains
% subImg = dataND(coorDomains{:});
% 
% end
% 
