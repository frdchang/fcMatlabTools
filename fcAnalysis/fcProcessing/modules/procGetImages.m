function [ fileOutputs ] = procGetImages( expFolder,regexpMatch,saveName,specimenUnits)
%PROCGETIMAGES Summary of this function goes here
%   Detailed explanation goes here

files      = getAllFiles(expFolder,'tif');
if iscell(regexpMatch)
    files      = cellfunNonUniformOutput(@(x) keepCertainStringsIntersection(files,x),regexpMatch);
    temp = cell(numel(files{1}),1);
    for ii = 1:numel(files{1})
        temp{ii} = cellfun(@(x) x(ii),files);
    end
    files = temp;
else
    files      = keepCertainStringsIntersection(files,regexpMatch);
    
end

fileOutputs.outputFiles = table(files,'VariableNames',{'files'});
fileOutputs.regexpMatch = regexpMatch;

output.expFolder = expFolder;
output.units     = specimenUnits;
fileOutputs = procSaver(output,fileOutputs,saveName);

end

