function output = saveToProcessed_stageAlign(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_GETXYSTAGEALIGNMENT Summary of this function goes here
%   Detailed explanation goes here

pathOnly        = returnFilePath(filePathOfInput);
fileName        = calcConsensusString(returnFileName(filePathOfInput));
savePath        = createProcessedDir(pathOnly);
savePath        = calcConsensusString(savePath);
functionName    =  char(myFunc);
if isempty(funcParamHash)
    saveFolder = ['[' functionName ']'];
else
    saveFolder = ['[' functionName '(' funcParamHash ')]'];
end
saveFolder = [savePath filesep saveFolder];
[~,~,~] = mkdir(saveFolder);

saveProcessedFileAt = removeDoubleFileSep([saveFolder filesep functionName '(' fileName ')']);
xyAlignment = funcOutput{1};
save(saveProcessedFileAt,'xyAlignment');
output = saveProcessedFileAt;