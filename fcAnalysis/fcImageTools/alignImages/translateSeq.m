function outputFiles = translateSeq(listOfData,translationSequence,varargin)
%TRANSLATETIMELAPSE Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


outputFiles = cell(numel(listOfData),1);
if ischar(translationSequence)
    translationSequence = load(translationSequence);
    translationSequence = translationSequence.xyAlignment;
end
setupParForProgress(numel(listOfData));
if params.doParallel
    parfor ii = 1:numel(listOfData)
        currStack = importStack(listOfData{ii});
        stackClass = class(currStack);
        currStack = double(currStack);
        shiftStack = translateImage(currStack,translationSequence(ii,1),translationSequence(ii,2));
        saveProcessedFileAt = genProcessedFileName(listOfData{ii},'translateSeq');
        if isequal(stackClass,'uint8')
            shiftStack = norm2UINT255(shiftStack);
        end
        outputFiles{ii} = exportStack(saveProcessedFileAt,shiftStack);
        incrementParForProgress();
    end
else
    for ii = 1:numel(listOfData)
        currStack = importStack(listOfData{ii});
        stackClass = class(currStack);
        currStack = double(currStack);
        shiftStack = translateImage(currStack,translationSequence(ii,1),translationSequence(ii,2));
        saveProcessedFileAt = genProcessedFileName(listOfData{ii},'translateSeq');
        if isequal(stackClass,'uint8')
            shiftStack = norm2UINT255(shiftStack);
        end
        outputFiles{ii} = exportStack(saveProcessedFileAt,shiftStack);
        incrementParForProgress();
    end
end


