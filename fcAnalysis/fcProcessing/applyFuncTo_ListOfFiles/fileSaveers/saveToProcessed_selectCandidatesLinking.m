function [ mainOutput ] = saveToProcessed_selectCandidatesLinking( listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin )
%SAVETOPROCESSED_SELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here


% save each one individually
paths = listOfFileInputPaths{1};
outputs = funcOutput{1};
output = cell(2,1);
mainOutput = cell(numel(paths),1);
for ii = 1:numel(paths)
    currPath = paths{ii};
    funcOutput = outputs{ii};
    saveProcessedFileAt = genProcessedFileName(currPath,myFunc,'paramHash',funcParamHash);
    output{1} = [saveProcessedFileAt '.mat'];
    makeDIRforFilename(saveProcessedFileAt);
    savefast(saveProcessedFileAt,'funcOutput');
    saveImages = [returnFilePath(saveProcessedFileAt) filesep 'images' filesep 'img_' returnFileName(saveProcessedFileAt) '.tif'];
    L = maxintensityproj(funcOutput.L,3);
    L = label2rgb(L,'jet','k','shuffle');
    makeDIRforFilename(saveImages);
    output{2} = saveImages;
    imwrite(L,saveImages);
    output = convertListToListofArguments(output);
    mainOutput{ii} = table(output{:},'VariableNames',{'mat','rgbL'});
end
mainOutput = vertcat(mainOutput{:});

