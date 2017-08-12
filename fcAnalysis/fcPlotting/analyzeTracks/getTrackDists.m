function [ output_args ] = getTrackDists( tracks )
%GETTRACKDISTS Summary of this function goes here
%   Detailed explanation goes here

trackTimePoints = cellfunNonUniformOutput(@(x) x(:,1),tracks);
C = nchoosek(1:3,2)

minTime = cellfun(@min,trackTimePoints);
maxTime = cellfun(@max,trackTimePoints);


end

