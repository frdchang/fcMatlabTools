function [aligned] = doAlignment(data,peaksInData)
%DOALIGNMENT Summary of this function goes here
%   Detailed explanation goes here

aligned = {};

for ii = 1:numel(peaksInData)
   currPeaks = peaksInData{ii};
   for jj =1:numel(currPeaks)
      aligned{end+1} = alignProfilesToCenter(data{ii},currPeaks(jj));
   end
end
end

