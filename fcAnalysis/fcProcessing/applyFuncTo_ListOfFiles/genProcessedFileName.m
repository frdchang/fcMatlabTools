function saveProcessedFileAt = genProcessedFileName(filePathOfInput,myFunc,varargin)
%GENPROCESSEDFILENAME creates the appropriate filepath for processed files
% you can provide a parameter hash for varargin

if ischar(filePathOfInput)
    filePathOfInput = {filePathOfInput};
end
% save to the first argument
if all(cellfun(@ischar, filePathOfInput))
    
else
    filePathOfInput = flattenCellArray(filePathOfInput);
end
pathOnly        = unique(returnFilePath(filePathOfInput),'stable');
pathOnly        = pathOnly{1};
% get filenames of all arguments

fileName        = cellfunNonUniformOutput(@(x)calcConsensusString(returnFileName(x)),filePathOfInput);
savePath        = createProcessedDir(pathOnly);
functionName    =  char(myFunc);
if isempty(varargin) || isempty(varargin{1})
    saveFolder = [filesep '[' functionName ']' filesep];
else
    saveFolder = [filesep '[' functionName '(' varargin{1} ')]' filesep];
end
newFileName     = [functionName '(' strjoin(fileName,',') ')'];

% history of applied functions are in the bracketed portions of filepath
grabHistory     = regexp(savePath,'\[(.*?)\]','match');
grabRest        = regexp(savePath,'\[(.*?)\]','split');
history         = {strjoin(grabHistory,'')};
% history         = regexprep(history,'\]\[','');
% append current function to first part of grabHistory
grabRest{1} = [grabRest{1} saveFolder];



pathToProcessedSaveFolder = interleave(grabRest,history);
pathToProcessedSaveFolder = strcat(pathToProcessedSaveFolder{:});
[~,~,~] = mkdir(pathToProcessedSaveFolder);

saveProcessedFileAt = removeDoubleFileSep([pathToProcessedSaveFolder filesep newFileName]);

end

