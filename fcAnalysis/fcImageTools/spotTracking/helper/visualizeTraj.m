function [h] = visualizeTraj( tracked )
%VISUALIZETRAJ Summary of this function goes here
%   Detailed explanation goes here
numTracks = numel(tracked);
myMap     = distinguishable_colors(numTracks,[0 0 0]);
hold on;
for ii=1:numTracks
   currTrack =  tracked{ii};
   X = currTrack(:,2);
   Y = currTrack(:,3);
   Z = currTrack(:,4);
   line(X,Y,Z,'Marker','o','Color',myMap(ii,:));

end

