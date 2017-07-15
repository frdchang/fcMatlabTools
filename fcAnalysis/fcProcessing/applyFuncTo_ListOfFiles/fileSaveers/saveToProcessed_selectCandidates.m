function [ output ] = saveToProcessed_selectCandidates( listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin )
%SAVETOPROCESSED_SELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash);

funcOutput = funcOutput{1};
makeDIRforFilename(saveProcessedFileAt);
save(saveProcessedFileAt,'funcOutput');

output = [saveProcessedFileAt '.mat'];

% save thresholded images 

saveImages = [returnFilePath(saveProcessedFileAt) filesep 'images' filesep 'img_' returnFileName(saveProcessedFileAt) '.tif'];
L = maxintensityproj(funcOutput.L,3);
L = label2rgb(L,'jet','k','shuffle');
makeDIRforFilename(saveImages);
imwrite(L,saveImages);
end

