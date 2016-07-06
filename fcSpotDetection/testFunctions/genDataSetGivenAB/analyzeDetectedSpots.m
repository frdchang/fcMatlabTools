function [ output_args ] = analyzeDetectedSpots(pathToDataSets)
%ANALYZEDETECTEDSPOTS Summary of this function goes here
%   Detailed explanation goes here

spotData = grabScatteredData(pathToDataSets,'fcSpotDetection',@openData_grabScatteredData);
spotDataOrganized = getOrderedListFromMatch(spotData.dataFileNames,'-[0-9]+','ascend');

numExperiments = numel(spotDataOrganized);


for ii = 1:numExperiments
    % find index for each experiment
   currExperiment = spotDataOrganized{ii}.subMatch;
   currExperimentIndices = returnIndicesFromMatch(spotData.dataFileNames,currExperiment);
   currExpPaths = spotData.dataFileNames(currExperimentIndices);
   currDatas    = spotData.datas(currExperimentIndices);
   
end

