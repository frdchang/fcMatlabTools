function outputFiles = translateSeq(containerInput,varargin)
%TRANSLATETIMELAPSE Summary of this function goes here
%   Detailed explanation goes here
listOfData = containerInput{1};
translationSequence = containerInput{2};
outputFiles = cell(numel(listOfData),1);
if ischar(translationSequence)
   translationSequence = load(translationSequence); 
   translationSequence = translationSequence.xyAlignment;
end
for ii = 1:numel(listOfData)
   currStack = importStack(listOfData{ii});
   shiftStack = translateImage(currStack,translationSequence(ii,1),translationSequence(ii,2));
   saveProcessedFileAt = genProcessedFileName(listOfData{ii},'translateSeq');
   exportStack(saveProcessedFileAt,shiftStack);
   outputFiles{ii} = saveProcessedFileAt;
end

