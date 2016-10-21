function saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,varargin)
%GENPROCESSEDFILENAME creates the appropriate filepath for processed files
% you can provide a parameter hash for varargin

%--parameters--------------------------------------------------------------
params.paramHash     = [];
params.appendFolder  = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if ischar(listOfFileInputPaths)
    listOfFileInputPaths = {listOfFileInputPaths};
end

allThePaths = cellfunNonUniformOutput(@(x) calcConsensusString(returnFilePath(x)),listOfFileInputPaths);
allTheFileNames = cellfunNonUniformOutput(@(x) calcConsensusString(returnFileName(x)),listOfFileInputPaths);
allTheFileNamesDroppedVowels = dropVowels(allTheFileNames);
savePath = createProcessedDir(allThePaths{1});
fileInputs = strjoin(allTheFileNamesDroppedVowels,',');

functionName    =  char(myFunc);
functionNameDroppedVowels = dropVowels(functionName);
if isempty(params.paramHash)
    saveFolder = [filesep '[' functionName ']' filesep];
else
    saveFolder = [filesep '[' functionName '(' params.paramHash ')]' filesep];
end

if isempty(params.appendFolder)
    newFileName     = [functionName '(' fileInputs ')'];
else
    newFileName     = [params.appendFolder filesep params.appendFolder '(' fileInputs ')'];
end
% history of applied functions are in the bracketed portions of filepath
grabHistory     = regexp(savePath,'\[(.*?)\]','match');
grabRest        = regexp(savePath,'\[(.*?)\]','split');
history         = {strjoin(grabHistory,'')};
history         = dropVowels(history);
% history         = regexprep(history,'\]\[','');
% append current function to first part of grabHistory
grabRest{1} = [grabRest{1} saveFolder];

pathToProcessedSaveFolder = interleave(grabRest,history);
pathToProcessedSaveFolder = strcat(pathToProcessedSaveFolder{:});
saveProcessedFileAt = removeDoubleFileSep([pathToProcessedSaveFolder filesep newFileName]);





% if ischar(listOfFileInputPaths)
%     listOfFileInputPaths = {listOfFileInputPaths};
% end
% % save to the first argument
% if all(cellfun(@ischar, listOfFileInputPaths))
%
% else
%     listOfFileInputPaths = flattenCellArray(listOfFileInputPaths);
% end
% pathOnly        = unique(returnFilePath(listOfFileInputPaths),'stable');
% pathOnly        = pathOnly{1};
% % get filenames of all arguments
%
% fileName        = cellfunNonUniformOutput(@(x)calcConsensusString(returnFileName(x)),listOfFileInputPaths);
% savePath        = createProcessedDir(pathOnly);
% functionName    =  char(myFunc);
% if isempty(varargin) || isempty(varargin{1})
%     saveFolder = [filesep '[' functionName ']' filesep];
% else
%     saveFolder = [filesep '[' functionName '(' varargin{1} ')]' filesep];
% end
% newFileName     = [functionName '(' strjoin(fileName,',') ')'];
%
% % history of applied functions are in the bracketed portions of filepath
% grabHistory     = regexp(savePath,'\[(.*?)\]','match');
% grabRest        = regexp(savePath,'\[(.*?)\]','split');
% history         = {strjoin(grabHistory,'')};
% % history         = regexprep(history,'\]\[','');
% % append current function to first part of grabHistory
% grabRest{1} = [grabRest{1} saveFolder];
%
%
%
% pathToProcessedSaveFolder = interleave(grabRest,history);
% pathToProcessedSaveFolder = strcat(pathToProcessedSaveFolder{:});
% % [~,~,~] = mkdir(pathToProcessedSaveFolder);
%
% saveProcessedFileAt = removeDoubleFileSep([pathToProcessedSaveFolder filesep newFileName]);

end

