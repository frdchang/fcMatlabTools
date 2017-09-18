function output = saveToProcessed_yeastSeg(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_YEASTSEG Summary of this function goes here
%   Detailed explanation goes here
saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths{1},myFunc,'paramHash',funcParamHash);
segOutput = funcOutput{1};
% save individual mat
makeDIRforFilename(saveProcessedFileAt);
save(saveProcessedFileAt,'segOutput','-v7.3');
% save timelapse of segmentation
inputFiles = listOfFileInputPaths{1};
segSequenceFiles = cell(numel(inputFiles),1);
for ii = 1:numel(inputFiles)
    saveSegTimePointAt = genProcessedFileName(inputFiles{ii},myFunc,'paramHash',funcParamHash);
    saveFolder = returnFilePath(saveSegTimePointAt);
    saveFile   = returnFileName(saveSegTimePointAt);
    savePath   = [saveFolder filesep 'seq' filesep saveFile];
    segSequenceFiles{ii} = exportStack(savePath,segOutput.all_obj.cells(:,:,ii));
end

segMatFile = [saveProcessedFileAt '.mat'];
output = table({segMatFile},{segSequenceFiles},'VariableNames',{'mat','tifs'});

