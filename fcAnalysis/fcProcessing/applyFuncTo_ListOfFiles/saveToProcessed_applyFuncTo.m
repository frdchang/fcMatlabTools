function [] = saveToProcessed_applyFuncTo(filePath,myFunc,myFuncParams,funcOutput,varargin)
%SAVETOPROCESSED_APPLYFUNCTO simply savest he funcOuptut as a mat file with
%fcData -> fcProcessed

pathOnly = returnFilePath(filePath);
fileName = returnFileName(filePath);
savePath = createProcessedDir(pathOnly);
functionName = ['[' char(myFunc) ']'];
% paramHash = DataHash(myFuncParams);

saveFolder = [functionName];

saveProcessedFileAt = [savePath filesep saveFolder filesep functionName '-' fileName];
makeDIRforFilename(saveProcessedFileAt);
save(saveProcessedFileAt,'funcOutput');
end

