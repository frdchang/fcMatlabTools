function output = saveToProcessed_fcSpotDetection(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_IMAGES will save funcOutput as a bunch of images
% funcOutput = [spotParams,estimated,candidates]
%
% if desired, varargin should contain the name of the files to be appended
% .../fcData/.../input
%
% .../fcProcessed/.../[myFunc(paramHash)]/myFunc(input).fits
% if the image is a uint8 or 16 it will save as tif
saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash);

output = cell(3,1);
% loop over funcOutput and save
% for ii = 1:numel(funcOutput)
%    currImage = funcOutput{ii};
%    saveProcessedFileAt = [saveFolder filesep functionName '(' fileName ')_' varargin{ii}];
%    output{ii} = saveProcessedFileAt;
%    if isinteger(currImage)
%       exportSingleTifStack(saveProcessedFileAt,currImage);
%    else
%       exportSingleFitsStack(saveProcessedFileAt,currImage);
%    end
% end

% save first func output
outputName = 'MLE_thetas';
saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',outputName);
makeDIRforFilename(saveProcessedFileAt);
output{1} = [saveProcessedFileAt '.mat'];
spotParams = funcOutput{1};
try
    save(saveProcessedFileAt,'-v6','spotParams');
catch
end

outputName = 'MLE_A1';
saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',outputName);

makeDIRforFilename(saveProcessedFileAt);
saveOutput = funcOutput{2}.A1;
output{2} = exportStack(saveProcessedFileAt,saveOutput);

outputName = 'MLE_LLRatio';
saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',outputName);
makeDIRforFilename(saveProcessedFileAt);
saveOutput = funcOutput{2}.LLRatio;
output{3} = exportStack(saveProcessedFileAt,saveOutput);

