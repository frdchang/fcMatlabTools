function [] = analyzeDataSet(pathToGenDataFolder)
%ANALYZEDATASET Summary of this function goes here
%   Detailed explanation goes here

dataSetFolders = getLocalFolders(pathToGenDataFolder,'A[0-9]+-B[0-9]+');

for i = 1:numel(dataSetFolders)
    currDataList = getLocalFiles(dataSetFolders{i},'fits');
    for j = 1:numel(currDataList)
       data = importStack(currDataList{j});
       
    end
end


