function [ output ] = saveToProcessed_translateSpots(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_TRANSLATESPOTS Summary of this function goes here
%   Detailed explanation goes here
outputFileName = genProcessedFileName(listOfFileInputPaths{3},myFunc,'paramHash',funcParamHash);
makeDIRforFilename(outputFileName);
save(outputFileName,'funcOutput');

% output = funcOutput{1};
output = table({outputFileName},'VariableNames',{'xy_stageIIMLEs'});
end

