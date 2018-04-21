function [ outputFiles ] = saveToProcessed_extractSpots(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_EXTRACTSPOTS Summary of this function goes here
%   Detailed explanation goes here
saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths{2},myFunc,'paramHash',funcParamHash);
saveProcessedFileAt = [saveProcessedFileAt '.mat'];
saveWithName(funcOutput{1},saveProcessedFileAt,'extractSpots');
outputFiles = table({saveProcessedFileAt},'VariableNames',{'mat'});
end

