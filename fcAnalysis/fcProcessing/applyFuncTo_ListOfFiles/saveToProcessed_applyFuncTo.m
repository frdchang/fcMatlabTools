function saveProcessedFileAt = saveToProcessed_applyFuncTo(filePath,myFunc,myFuncParams,funcOutput,paramHash,inputHash,varargin)
%SAVETOPROCESSED_APPLYFUNCTO simply savest he funcOuptut as a mat file with
% filepath =  .../fcData/..../data.ext to
% .../fcProcessed/.../funcName-paramHash/funcName(data.ext).mat
% or
% .../fcProcessed/.../funcName-paramHash/funcName(data1.ext,data2.ext).mat
% if the filePath is a cell list of
% {.../fcData/..../data1.ext,.../fcData/..../data2.ext}
% and the filepath modifies data1.ext's path



if isempty(varargin)
    fileName = returnFileName(filePath);
    functionName = ['[' char(myFunc) ']'];
    saveProcessedFileAt = [saveFolder filesep functionName '(' fileName ')'];
    save(saveProcessedFileAt,'funcOutput');
else
    pathOnly = returnFilePath(filePath);
    savePath = createProcessedDir(pathOnly);
    functionName = ['[' char(myFunc) ']'];

    saveFolder = [functionName '(' paramHash ',' inputHash ')'];
    saveFolder = [savePath filesep saveFolder];
    [~,~,~] = mkdir(saveFolder);
    return;
end
