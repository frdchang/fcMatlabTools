function saveProcessedFileAt = saveToProcessed_applyFuncTo(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_APPLYFUNCTO will save funcOutput that came from myFunc
%applied to the inputs coming from filePathOfInput to a modified path of
%filePathOfInput.  
% 
% .../fcData/.../input
%
% .../fcProcessed/.../[myFunc(paramHash)]/myFunc(input).mat

pathOnly        = returnFilePath(filePathOfInput);
fileName        = returnFileName(filePathOfInput);
savePath        = createProcessedDir(pathOnly);
functionName    =  char(myFunc);
if isempty(funcParamHash)
    saveFolder = ['[' functionName ']'];
else
    saveFolder = ['[' functionName '(' funcParamHash ')]'];
end
saveFolder = [savePath filesep saveFolder];
[~,~,~] = mkdir(saveFolder);

saveProcessedFileAt = [saveFolder filesep functionName '(' fileName ')'];
save(saveProcessedFileAt,'funcOutput');


