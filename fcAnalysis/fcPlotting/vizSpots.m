function [ output_args ] = vizSpots(img,spots,varargin )
%VIZSPOTS Summary of this function goes here
%   Detailed explanation goes here

 
for ii = 1:numel(img)
    currStack = importStack(img{ii});
    currSpot = spots{ii};
end
 spotSelected  = spotSelectorByThresh(currSpot,varargin{:});

fluorViews = buildView(img,[1 1 1]);
spotViews  = buildViewSpots(img,spots,[1 1 1],varargin{:});
