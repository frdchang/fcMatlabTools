function [ T_edgeProfileZs ] = procGetEdgeProfileZ(T_phaseOutputs,indexInT)
%PROCGETEDGEPROFILEZ Summary of this function goes here
%   Detailed explanation goes here

phaseFiles = T_phaseOutputs.outputFiles.files;
numTimelapses = numel(phaseFiles);
outputFiles = cell(numTimelapses,1);
if ~ischar(indexInT)
    indexInT = num2str(indexInT);
end

for ii = 1:numTimelapses
    stack = importStack(eval( ['phaseFiles{' num2str(ii) '}{' indexInT '}']));
    outputFiles{ii} = getEdgeProfileZ(stack);
end

T_edgeProfileZs.inputFiles = phaseFiles;
T_edgeProfileZs.outputFiles = table(outputFiles','VariableNames',{'edgeProfileZ'});

procSaver(T_phaseOutputs,T_edgeProfileZs);

end

