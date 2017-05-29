function [ candidates ] = genCandidatesFromTheta0(sizeData,thetaTrue,sizeKern)
%GENCANDIDATESFROMTHETA0 Summary of this function goes here
%   Detailed explanation goes here

% define candidates
L = zeros(sizeData);
spotCoors = getSpotCoorsFromTheta(thetaTrue);
for zz = 1:numel(spotCoors)
    cellCoor = num2cell(spotCoors{zz});
    L(cellCoor{:}) = 1;
end

L = imdilate(L,strel(ones(sizeKern(:)')));
L = bwlabeln(L>0);
stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');

currMask = L == 1;
candidates.L = currMask;
candidates.stats = stats;
end

