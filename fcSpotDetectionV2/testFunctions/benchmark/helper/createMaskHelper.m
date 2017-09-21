function [ currMask,stats ] = createMaskHelper( stack,sizeKern,thetaTrue)
%CREATEMASKHELPER given stack and such will create mask

% define candidates
L = zeros(size(stack{1}));
spotCoors = getSpotCoorsFromTheta(thetaTrue);
for zz = 1:numel(spotCoors)
    cellCoor = num2cell(spotCoors{zz});
    L(cellCoor{:}) = 1;
end

L = imdilate(L,strel(ones(sizeKern(:)')));
L = bwlabeln(L>0);
stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');

currMask = L == 1;
end

