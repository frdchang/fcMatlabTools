function [ trackedKymos ] = genKymosFromViews( overlayedTracks )
%GENKYMOSFROMVIEWS Summary of this function goes here
%   Detailed explanation goes here

numTimePoints = size(overlayedTracks,2);
trackedKymos = cell(3,1);

a = permute(max(overlayedTracks{1,1},[],1),[2 1 3]);
b = max(overlayedTracks{1,1},[],2);
c = max(overlayedTracks{3,1},[],2);

[trackedKymos{:}] = deal(zeros(size(a,1),numTimePoints,3),zeros(size(b,1),numTimePoints,3),zeros(size(c,1),numTimePoints,3));

for ii = 1:numTimePoints
   trackedKymos{1}(:,ii,:) = permute(maxintensityproj4RGB(overlayedTracks{1,ii},1),[2 1 3]);
   trackedKymos{2}(:,ii,:) = maxintensityproj4RGB(overlayedTracks{1,ii},2);
   trackedKymos{3}(:,ii,:) = maxintensityproj4RGB(overlayedTracks{3,1},2);
end

% trackedKymos = cellfunNonUniformOutput(@norm2UINT255,trackedKymos);
end

