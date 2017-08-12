function [ tracks ] = filterTracksByLength( tracks, minLength,maxLength)
%FILTERTRACKSBYLENGTH Summary of this function goes here
%   Detailed explanation goes here

trackL= cellfun(@(x) size(x,1),tracks);

permissiveTracks = trackL >= minLength & trackL <= maxLength;

tracks(~permissiveTracks) = [];

end

