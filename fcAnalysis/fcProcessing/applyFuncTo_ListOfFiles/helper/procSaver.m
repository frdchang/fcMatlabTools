function outputVariable = procSaver(expFolder,outputVariable,varargin)
%PROCSAVER will save the variable at path

saveVersion = '-v7';

if isstruct(expFolder)
    if isfield(expFolder,'units')
    units     = expFolder.units;
    else
        units = [];
    end
    expFolder = expFolder.expFolder;
end

if ~isempty(varargin)
    newName = varargin{1};
else
    newName = inputname(2);
end

outputVariable.expFolder = expFolder;
outputVariable.units     = units;
saveFile = strcat(expFolder,filesep,'processingState');
saveFile = [saveFile '.mat'];
saveFile = createProcessedDir(saveFile);
makeDIRforFilename(saveFile);
S.(newName) = outputVariable;
if exist(saveFile,'file')==0
    save(saveFile, '-struct', 'S',saveVersion);
else
    save(saveFile, '-struct', 'S','-append');
end

end