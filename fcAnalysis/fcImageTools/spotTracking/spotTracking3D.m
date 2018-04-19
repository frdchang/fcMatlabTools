function [ tracked ] = spotTracking3D(listOfSpotMLEs,varargin)
%SPOTTRACKING3D listOFSpotsMLEs, first dimension is timepoint, second
%dimension is the spot number and the struct is the localization
% for future note: i can extract the variance of the estimator and have it
% outputed for the tracks.  so the tracked datastructure should already be
% so it can gracefully have this info appended ot it.
% 

%--parameters--------------------------------------------------------------
params.noSpotCoorVal     = -100;
params.searchDist        = 100;
params.specimenUnitsInMicrons = [1 1 1];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

emptyCoor = params.noSpotCoorVal*[1 1 1 1 1 1]';
% calulate how many channels there are
numChans = getNumChansFromMLE(listOfSpotMLEs);

numTimePoints = numel(listOfSpotMLEs);
peaks = cell(numTimePoints,1);
peaksPerChan = cell(numChans,1);
[peaksPerChan{:}] = deal(peaks);
 
% populate peak dataset from MLEs to pass to trackers
for ii = 1:numTimePoints
    spotList = listOfSpotMLEs{ii};
    if isempty(spotList)
       for kk = 1:numChans
          peaksPerChan{kk}{ii}{end+1} = emptyCoor;
       end
    else
       numSpots = numel(spotList);
       for jj = 1:numSpots
           currSpot = spotList{jj};
           spotSelected  = spotSelectorByThresh(currSpot,params);
           if isempty(spotSelected)
              continue; 
           end
           spotXYZs = getXYZABFromTheta(spotSelected.thetaMLEs);
           for kk = 1:numel(spotXYZs)
               if ~isempty(spotXYZs{kk})
                   spotsAtT  = spotXYZs{kk};
                   for ll = 1:numel(spotsAtT)
                       currCoor = spotsAtT{ll};
                       currCoor = currCoor.*[params.specimenUnitsInMicrons 1 1];
                       makePeakSpot = [currCoor -1]';
                       peaksPerChan{kk}{ii}{end+1} = makePeakSpot;
                   end
               else
                   peaksPerChan{kk}{ii}{end+1} = emptyCoor;
               end
           end
       end
    end
end


% convert cell list to matrix
for ii = 1:numChans
    for jj = 1:numTimePoints
        peaksPerChan{ii}{jj} = cell2mat(peaksPerChan{ii}{jj})';
    end
end

[trackers,energies] = cellfun(@(x) link_trajectories3D(x,params.searchDist),peaksPerChan,'uni',false);
trackers = cellfunNonUniformOutput(@(trackers) cellfunNonUniformOutput(@(x) x./[params.specimenUnitsInMicrons 1 1 1],trackers),trackers);

tracked = cellfun(@(trackers) extractTrajs(trackers),trackers,'uni',false);
tracked = cellfunNonUniformOutput(@(x) removeEmptyCoor(x,emptyCoor),tracked);
end

function trackers  = removeEmptyCoor(trackers,emptyCoor)
trackers = cellfunNonUniformOutput(@(x) removeHelper(x,emptyCoor),trackers);
trackers = removeEmptyCells(trackers);
end

function aTrack = removeHelper(aTrack,emptyCoor)
idx = ismember(aTrack(:,2:6),emptyCoor(1:5)','rows');
aTrack(idx,:) = [];
end

