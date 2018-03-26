function [ tracks ] = filterTracksByLength( tracks, minLength,maxLength)
%FILTERTRACKSBYLENGTH Summary of this function goes here
%   Detailed explanation goes here

trackL= cellfun(@(x) size(x,1),tracks);

permissiveTracks = trackL >= minLength & trackL <= maxLength;

tracks(~permissiveTracks) = [];

trackIsPos = cellfun(@(x) all(all(x(:,2:6)>=0)),tracks);
tracks(~trackIsPos) = [];
end

