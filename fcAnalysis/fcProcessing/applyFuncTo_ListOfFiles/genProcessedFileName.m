function saveProcessedFileAt = genProcessedFileName(filePathOfInput,myFunc,varargin)
%GENPROCESSEDFILENAME creates the appropriate filepath for processed files
% you can provide a parameter hash for varargin

pathOnly        = returnFilePath(filePathOfInput);
fileName        = calcConsensusString(returnFileName(filePathOfInput));
savePath        = createProcessedDir(pathOnly);
savePath        = calcConsensusString(savePath);
functionName    =  char(myFunc);
if isempty(varargin)
    saveFolder = ['[' functionName ']'];
else
    saveFolder = ['[' functionName '(' varargin{1} ')]'];
end
saveFolder = [savePath filesep saveFolder];
[~,~,~] = mkdir(saveFolder);

saveProcessedFileAt = removeDoubleFileSep([saveFolder filesep functionName '(' fileName ')']);

end

