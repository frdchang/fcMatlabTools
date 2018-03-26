function [ output ] = saveToProcessed_direct(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_DIRECT Summary of this function goes here
%   Detailed explanation goes here

saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash);

if numel(funcOutput) == 1 && iscell(funcOutput)
    funcOutput = funcOutput{1};
    makeDIRforFilename(saveProcessedFileAt);
    save(saveProcessedFileAt,'funcOutput');
else
    makeDIRforFilename(saveProcessedFileAt);
    save(saveProcessedFileAt,'funcOutput');
end
output = [saveProcessedFileAt '.mat'];
end

