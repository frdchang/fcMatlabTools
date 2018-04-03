function [ fileOutputs ] = procGetImages( expFolder,regexpMatch,saveName,specimenUnits)
%PROCGETIMAGES Summary of this function goes here
%   Detailed explanation goes here

files      = getAllFiles(expFolder,'tif');
files = keepCertainStringsUnion(files,regexpMatch);
if iscell(regexpMatch)
    files = keepOrderedStrings(files,regexpMatch);
    files = glueCells(files{:});
else
    files      = keepCertainStringsIntersection(files,regexpMatch);
    
end

fileOutputs.outputFiles = table(files,'VariableNames',{'files'});
fileOutputs.regexpMatch = regexpMatch;

output.expFolder = expFolder;
output.units     = specimenUnits;
fileOutputs = procSaver(output,fileOutputs,saveName);

end

