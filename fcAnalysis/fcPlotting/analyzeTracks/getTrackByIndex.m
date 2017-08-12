function [ indexTrack ] = getTrackByIndex( tracks,index )
%GETTRACK Summary of this function goes here
%   Detailed explanation goes here

tracks = flattenCellArray(tracks);
% trackTimePoints = cellfunNonUniformOutput(@(x) x(:,1),tracks);
numTracks       = numel(tracks);

indexTrack = cell(numTracks,1);
for ii = 1:numTracks
    currTrack = tracks{ii};
    trackTime = currTrack(:,1);
    trackIndex = currTrack(:,1+index);
    indexTrack{ii}.t = trackTime;
    indexTrack{ii}.d = trackIndex;
end


