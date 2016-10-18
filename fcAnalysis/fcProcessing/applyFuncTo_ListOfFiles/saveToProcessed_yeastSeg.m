function output = saveToProcessed_yeastSeg(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_YEASTSEG Summary of this function goes here
%   Detailed explanation goes here
saveProcessedFileAt = genProcessedFileName(filePathOfInput,myFunc,funcParamHash);
yeastSegOutput = funcOutput{1};
% save individual mat
save(saveProcessedFileAt,'yeastSegOutput');
% save timelapse of segmentation
inputFiles = filePathOfInput{1};
segSequenceFiles = cell(numel(inputFiles),1);
for ii = 1:numel(inputFiles)
    saveSegTimePointAt = genProcessedFileName({inputFiles{ii},filePathOfInput{2}},myFunc,funcParamHash);
    exportStack(saveSegTimePointAt,yeastSegOutput.all_obj.cells(:,:,ii));
    segSequenceFiles{ii} = saveSegTimePointAt;
end
output.segMatFile = saveProcessedFileAt;
output.segSequenceFiles = segSequenceFiles;

