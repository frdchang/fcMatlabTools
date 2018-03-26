function [peaksInData,peakMagInData] = findPeaksInData(data)
%FINDPEAKSINDATA Summary of this function goes here
%   Detailed explanation goes here

sel = 70000;
thresh = 3e4;
extrema = 1;
includeEndpoints = false;
interpolate = false;

numData = numel(data);
peaksInData = cell(numData,1);
peakMagInData = cell(numData,1);
for ii = 1:numData
    [peaksInData{ii},peakMagInData{ii}] = peakfinder(data{ii},sel,thresh,extrema,includeEndpoints,interpolate);
end



