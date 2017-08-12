function [ trackDists ] = getTrackDists( tracks )
%GETTRACKDISTS Summary of this function goes here
%   Detailed explanation goes here

tracks = flattenCellArray(tracks);
% trackTimePoints = cellfunNonUniformOutput(@(x) x(:,1),tracks);
numTracks       = numel(tracks);
trackDists = {};

if numTracks == 1
    return;
else
    idxCombos = nchoosek(1:numel(tracks),2);
    idxCombos = num2cell(idxCombos,2);
end

for ii = 1:numel(idxCombos)
    currCombo = idxCombos(ii);
    currTracks = tracks(currCombo{:});
    track1Time = currTracks{1}(:,1);
    track2Time = currTracks{2}(:,1);
    commonTimePoints = intersect(track1Time,track2Time);
    
    vector1 = currTracks{1}(ismember(track1Time,commonTimePoints),2:4);
    vector2 = currTracks{2}(ismember(track2Time,commonTimePoints),2:4);
    
    d = sum((vector1-vector2).^2,2);
    trackDists{end+1}.t = commonTimePoints;
    trackDists{end}.d   = d;
end


