function saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,varargin)
%GENPROCESSEDFILENAME creates the appropriate filepath for processed files
% you can provide a parameter hash for varargin

%--parameters--------------------------------------------------------------
params.paramHash      = [];
params.appendFolder   = [];
params.deleteHistory  = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if ischar(listOfFileInputPaths)
    listOfFileInputPaths = {listOfFileInputPaths};
end
listOfFileInputPaths = removeEmptyCells(listOfFileInputPaths);
allThePaths = cellfunNonUniformOutput(@(x) calcConsensusString(returnFilePath(x)),listOfFileInputPaths);
allTheFileNames = cellfunNonUniformOutput(@(x) calcConsensusString(returnFileName(x)),listOfFileInputPaths);
allTheFileNamesDroppedVowels = dropVowels(allTheFileNames);
savePath = createProcessedDir(allThePaths{1});
[cons,idxm] = calcConsensusString(allTheFileNamesDroppedVowels);

noncons = cellfunNonUniformOutput(@(x) x(~idxm), allTheFileNamesDroppedVowels);
inputFiles = {cons,noncons{:}};
inputFiles = deleteEmptyCells(inputFiles);
inputFiles = pruneUselessCharAtEdges(inputFiles);
inputFiles = deleteEmptyCells(inputFiles);
inputFiles = regexprep(inputFiles,'_w','');
% inputFiles = regexprep(inputFiles,'_','');
inputFiles = regexprep(inputFiles,'TTL','');
fileInputs = strjoin(inputFiles,',');

functionName    =  char(myFunc);
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
newFileName = dropVowels(newFileName);
% history of applied functions are in the bracketed portions of filepath
grabHistory     = regexp(savePath,'\[(.*?)\]','match');
grabRest        = regexp(savePath,'\[(.*?)\]','split');
if params.deleteHistory
    history = '';
else
    history         = {strjoin(grabHistory,'')};
    history         = dropVowels(history);
end

% history         = regexprep(history,'\]\[','');
% append current function to first part of grabHistory
grabRest{1} = [grabRest{1} saveFolder];

pathToProcessedSaveFolder = interleave(grabRest,history);
pathToProcessedSaveFolder = strcat(pathToProcessedSaveFolder{:});
saveProcessedFileAt = removeDoubleFileSep([pathToProcessedSaveFolder filesep newFileName]);

%% check if file name is too long, if so, hash it.

genFileName = returnFileName(saveProcessedFileAt);

if numel(genFileName) >= 255
    genFileName = DataHash(genFileName,struct('Format', 'base64', 'Method', 'MD5'));
    saveProcessedFileAt = [returnFilePath(saveProcessedFileAt) filesep genFileName];
end




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

