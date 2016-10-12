function output = saveToProcessed_fcSpotDetection(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_IMAGES will save funcOutput as a bunch of images
% funcOutput = [spotParams,estimated,candidates]
%
% if desired, varargin should contain the name of the files to be appended
% .../fcData/.../input
%
% .../fcProcessed/.../[myFunc(paramHash)]/myFunc(input).fits
% if the image is a uint8 or 16 it will save as tif


pathOnly        = returnFilePath(filePathOfInput);
fileName        = returnFileName(filePathOfInput);
savePath        = createProcessedDir(pathOnly);
functionName    =  char(myFunc);
if isempty(funcParamHash)
    saveFolder = ['[' functionName ']'];
else
    saveFolder = ['[' functionName '(' funcParamHash ')]'];
end
saveFolder = [savePath filesep saveFolder];
[~,~,~] = mkdir(saveFolder);


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
saveProcessedFileAt = [saveFolder filesep outputName filesep outputName '(' fileName ')'];
makeDIRforFilename(saveProcessedFileAt);
output{1} = saveProcessedFileAt;
spotMLEstructArray = funcOutput{1};
try
    save(saveProcessedFileAt,'-v6','spotMLEstructArray');
catch
end

outputName = 'MLE_A1';
saveProcessedFileAt = [saveFolder filesep outputName filesep outputName '(' fileName ')'];
makeDIRforFilename(saveProcessedFileAt);
output{2} = saveProcessedFileAt;
saveOutput = funcOutput{2}.A1;
exportStack(saveProcessedFileAt,saveOutput);

outputName = 'MLE_LLRatio';
saveProcessedFileAt = [saveFolder filesep outputName filesep outputName '(' fileName ')'];
makeDIRforFilename(saveProcessedFileAt);
output{3} = saveProcessedFileAt;
saveOutput = funcOutput{2}.LLRatio;
exportStack(saveProcessedFileAt,saveOutput);

