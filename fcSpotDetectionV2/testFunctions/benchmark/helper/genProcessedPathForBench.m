function [ procRoot,saveFolder ] = genProcessedPathForBench( benchStruct,folderName)
%GENPROCESSEDPATHFORBENCH Summary of this function goes here
%   Detailed explanation goes here

files =getFirstNonEmptyCellContent(benchStruct.conditions);
files = getFirstNonEmptyCellContent( getFirstNonEmptyCellContent(files.fileList));
processedPath = genProcessedFileName(files,[]);
procRoot = grabProcessedRest(processedPath);
procRoot = procRoot{1};
procRoot = traversePath(procRoot,1);

saveFolder = [procRoot filesep '[' folderName ']'];
saveFolder = removeDoubleFileSep(saveFolder);
end

