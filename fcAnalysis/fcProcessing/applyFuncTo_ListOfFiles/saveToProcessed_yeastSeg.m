function output = saveToProcessed_yeastSeg(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_YEASTSEG Summary of this function goes here
%   Detailed explanation goes here
saveProcessedFileAt = genProcessedFileName(filePathOfInput,myFunc,'paramHash',funcParamHash);
segOutput = funcOutput{1};
% save individual mat
makeDIRforFilename(saveProcessedFileAt);
save(saveProcessedFileAt,'segOutput');
% save timelapse of segmentation
inputFiles = filePathOfInput{1};
segSequenceFiles = cell(numel(inputFiles),1);
for ii = 1:numel(inputFiles)
    saveSegTimePointAt = genProcessedFileName({inputFiles{ii},filePathOfInput{2}},myFunc,'paramHash',funcParamHash);
    segSequenceFiles{ii} = exportStack(saveSegTimePointAt,segOutput.all_obj.cells(:,:,ii));
end
output.segMatFile = [saveProcessedFileAt '.mat'];
output.segSequenceFiles = segSequenceFiles;

