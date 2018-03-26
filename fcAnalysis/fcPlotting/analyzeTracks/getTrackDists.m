function [ trackDists,pairingSig ] = getTrackDists( tracks )
%GETTRACKDISTS returns track distances for all track combinations.
%pairing signature consists of [] if there is no track.  1 if there is a
%track and n if there are n tracks.  

tracks = flattenCellArray(tracks);
% trackTimePoints = cellfunNonUniformOutput(@(x) x(:,1),tracks);
numTracks       = numel(tracks);
trackDists = {};

% calculate pairingSig
all_t = cellfunNonUniformOutput(@(x) x(:,1),tracks);
all_t = unionm(all_t{:});
pairing = zeros(size(all_t));
for ii = 1:numTracks
   currTrack = tracks{ii};
   getTimePoints = currTrack(:,1);
   idxS = ismember(all_t,getTimePoints);
   pairing(idxS) = pairing(idxS) + 1;
end
pairingSig.t = all_t;
pairingSig.pairing = pairing;

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
    
    if isempty(commonTimePoints)
       continue; 
    end
    vector1 = currTracks{1}(ismember(track1Time,commonTimePoints),2:4);
    vector2 = currTracks{2}(ismember(track2Time,commonTimePoints),2:4);
    
    d = sum((vector1-vector2).^2,2);
    trackDists{end+1}.t = commonTimePoints;
    trackDists{end}.d   = d;
end


