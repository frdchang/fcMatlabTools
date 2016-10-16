function saveProcessedFileAt = genProcessedFileName(filePathOfInput,myFunc,varargin)
%GENPROCESSEDFILENAME creates the appropriate filepath for processed files
% you can provide a parameter hash for varargin

pathOnly        = calcConsensusString(returnFilePath(filePathOfInput));
fileName        = calcConsensusString(returnFileName(filePathOfInput));
savePath        = createProcessedDir(pathOnly);
functionName    =  char(myFunc);
if isempty(varargin) || isempty(varargin{1})
    saveFolder = [filesep '[' functionName ']' filesep];
else
    saveFolder = [filesep '[' functionName '(' varargin{1} ')]' filesep];
end
newFileName     = [functionName '(' fileName ')'];

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

