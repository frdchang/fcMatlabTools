function [ outputs ] = saveToProcessed_findSpotsStage2V2(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_FINDSPOTSSTAGE2V2 Summary of this function goes here
%   Detailed explanation goes here

fileInputs = listOfFileInputPaths{1};
saveProcessedFileAt = genProcessedFileName(fileInputs,myFunc,'paramHash',funcParamHash);

stageIIMLEs = funcOutput{1};
makeDIRforFilename(saveProcessedFileAt);
save(saveProcessedFileAt,'stageIIMLEs');
% outputs = table({[saveProcessedFileAt '.mat']},{stageIIMLEs},'VariableNames',{'pathToStageIIMLEs','stageIIMLEs'});
outputs = table({[saveProcessedFileAt '.mat']},'VariableNames',{'pathToStageIIMLEs'});



