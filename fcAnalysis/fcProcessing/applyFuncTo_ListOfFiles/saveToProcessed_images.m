function output = saveToProcessed_images(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_IMAGES will save funcOutput as a bunch of images
% if desired, varargin should contain the name of the files to be appended
% .../fcData/.../input
%
% .../fcProcessed/.../[myFunc(paramHash)]/myFunc(input).fits
% if the image is a uint8 or 16 it will save as tif
% s


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

if isempty(varargin)
   varargin = 1:numel(funcOutput); 
   varargin = strread(num2str(varargin),'%s');
end
output = cell(numel(funcOutput),1);
% loop over funcOutput and save
for ii = 1:numel(funcOutput)
   currImage = funcOutput{ii};
   saveProcessedFileAt = [saveFolder filesep functionName '(' fileName ')_' varargin{ii}];
   
   if isinteger(currImage)
      exportSingleTifStack(saveProcessedFileAt,currImage);
      output{ii} = [saveProcessedFileAt '.tif'];
   else
      exportSingleFitsStack(saveProcessedFileAt,currImage);
      output{ii} = [saveProcessedFileAt '.fits'];
   end
end




