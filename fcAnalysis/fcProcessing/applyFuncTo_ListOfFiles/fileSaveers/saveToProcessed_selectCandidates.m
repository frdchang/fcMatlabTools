function [ output ] = saveToProcessed_selectCandidates( listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin )
%SAVETOPROCESSED_SELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths{1},myFunc,'paramHash',funcParamHash);
output{2} = {};
funcOutput = funcOutput{1};
makeDIRforFilename(saveProcessedFileAt);
save(saveProcessedFileAt,'funcOutput');

output{1} = [saveProcessedFileAt '.mat'];

% save thresholded images 

saveImages = [returnFilePath(saveProcessedFileAt) filesep 'images' filesep 'img_' returnFileName(saveProcessedFileAt) '.tif'];
L = maxintensityproj(funcOutput.L,3);
L = label2rgb(L,'jet','k','shuffle');
makeDIRforFilename(saveImages);
imwrite(L,saveImages);

output{2} = saveImages;

VariableNames = {'mat','rgbL'};
output = convertListToListofArguments(output);
output = table(output{:},'VariableNames',VariableNames);
end

