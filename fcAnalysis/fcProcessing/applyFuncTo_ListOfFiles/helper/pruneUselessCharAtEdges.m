function [ inputFiles ] = pruneUselessCharAtEdges(inputFiles)
%PRUNEUSELESSCHARATEDGES Summary of this function goes here
%   Detailed explanation goes here

badStuffInBeg = cellfun(@isempty,regexp(inputFiles,'^[a-zA-Z0-9]'));
badStuffInEnd = cellfun(@isempty,regexp(inputFiles,'[a-zA-Z0-9]$'));

inputFiles(badStuffInBeg) = cellfunNonUniformOutput(@(x) x(2:end),inputFiles(badStuffInBeg));
inputFiles(badStuffInEnd) = cellfunNonUniformOutput(@(x) x(1:end-1),inputFiles(badStuffInEnd));

end

