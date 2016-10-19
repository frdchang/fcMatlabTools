function output = saveToProcessed_stageAlign(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_GETXYSTAGEALIGNMENT Summary of this function goes here
%   Detailed explanation goes here

saveProcessedFileAt = genProcessedFileName(filePathOfInput,myFunc,funcParamHash);
xyAlignment = funcOutput{1};
makeDIRforFilename(saveProcessedFileAt);
save(saveProcessedFileAt,'xyAlignment');
output = saveProcessedFileAt;