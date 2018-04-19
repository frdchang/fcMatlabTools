function [ trackedSpots,saveNumTracks ] = buildTrackSpots(numSeq,validTimePoints,tracks,sizeDatas,upRezFactor)
%BUILDTRACKSPOTS Summary of this function goes heres
%   Detailed explanation goes here

% %--parameters--------------------------------------------------------------
% params.default1     = 1;
% %--------------------------------------------------------------------------
% params = updateParams(params,varargin);


if all(cellfun(@isempty,tracks))
    trackedSpots = [];
    return;
end

% gen individual tracks
numChans = numel(tracks);

timeLapse = cell(numSeq,1);
trackedSpots = cell(numChans,1);
[trackedSpots{:}] = deal(timeLapse);
saveNumTracks = [];
for ii = 1:numChans
   currChan = tracks{ii};
   if ~isempty(currChan)
      numTracks = numel(currChan); 
      saveNumTracks(end+1) = numTracks;
      for jj = 1:numTracks
         currTrack = currChan{jj};
         for t = 1: size(currTrack,1)
             timepoint = currTrack(t,1);
             timepoint = find(validTimePoints==timepoint);
             xyz       = currTrack(t,2:4);
             A         = currTrack(t,5);
             B         = currTrack(t,6);
             currSpotImg = jj*genSpotIMG(xyz,sizeDatas,upRezFactor);
             if isempty(trackedSpots{ii}{timepoint})
                  trackedSpots{ii}{timepoint} = currSpotImg;
             else
                  trackedSpots{ii}{timepoint} = trackedSpots{ii}{timepoint}+currSpotImg;
             end
         end
      end
   end
end

% gen global tracks 

end

