function [] = saveToProcessed_applyFuncTo(filePath,myFunc,myFuncParams,funcOutput,varargin)
%SAVETOPROCESSED_APPLYFUNCTO simply savest he funcOuptut as a mat file with
% filepath =  .../fcData/..../data.ext to
% .../fcProcessed/.../funcName-paramHash/funcName(data.ext).mat
% or
% .../fcProcessed/.../funcName-paramHash/funcName(data1.ext,data2.ext).mat
% if the filePath is a cell list of
% {.../fcData/..../data1.ext,.../fcData/..../data2.ext}
% and the filepath modifies data1.ext's path
%
% paramHash must be run first since it dataHash cannot be run on a parfor
% loop.  so first setup directory by running 'setupDir' in varargin
% >> saveToProcessed_applyFuncTo(filePath,myFunc,myFuncParams,funcOutput,'setupDir')
% which creates the funcName-paramHash directory

persistent saveFolder;

if isempty(varargin)
    fileName = returnFileName(filePath);
    functionName = ['[' char(myFunc) ']'];
    saveProcessedFileAt = [saveFolder filesep functionName '(' fileName ')'];
    save(saveProcessedFileAt,'funcOutput');
else
    pathOnly = returnFilePath(filePath);
    savePath = createProcessedDir(pathOnly);
    functionName = ['[' char(myFunc) ']'];
    paramHash = DataHash(myFuncParams);
    saveFolder = [functionName '-' paramHash];
    saveFolder = [savePath filesep saveFolder];
    [~,~,~] = mkdir(saveFolder);
    return;
end
