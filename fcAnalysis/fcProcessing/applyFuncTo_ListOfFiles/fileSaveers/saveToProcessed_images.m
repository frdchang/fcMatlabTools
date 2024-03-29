function outputFileName = saveToProcessed_images(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_IMAGES will save funcOutput as a bunch of images
% if desired, varargin should contain the name of the files to be appended
% .../fcData/.../input
%
% .../fcProcessed/.../[myFunc(paramHash)]/myFunc(input).fits
% if the image is a uint8 or 16 it will save as tif
% s


saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash);

if isempty(varargin)
    if numel(funcOutput) == 1
        appendString{1} = '';
    else
        appendString = 1:numel(funcOutput);
        appendString = textscan(num2str(appendString),'%s');
        appendString = appendString{1};
    end
else
   appendString = varargin{1}; 
end

outputFileName = cell(numel(funcOutput),1);
variableNames = arrayfun(@(x) [func2str(myFunc) num2str(x)], 1:numel(myFunc),'UniformOutput',false);
fileOutputs = {};
for ii = 1:numel(funcOutput)
    currImage = funcOutput{ii};
    if isscalar(currImage)
       continue; 
    end
    if isempty(appendString{ii})
        outputFileName = saveProcessedFileAt;
    else
        outputFileName = [saveProcessedFileAt '_' appendString{ii}];
    end
    makeDIRforFilename(outputFileName);
    fileOutputs{end+1} = exportStack(outputFileName,currImage);
end
fileOutputs = convertListToListofArguments(fileOutputs);
outputFileName = table(fileOutputs{:},'VariableNames',variableNames);




