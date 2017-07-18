function [] = procSaver(expFolder,outputVariable,varargin)
%PROCSAVER will save the variable at path


if ~isempty(varargin)
    newName = varargin{1};
else
    newName = inputname(2);
end


saveFile = strcat(expFolder,filesep,'processingState');
saveFile = [saveFile '.mat'];

S.(newName) = outputVariable;

if exist(saveFile,'file')==0
    save(saveFile, '-struct', 'S');
else
    save(saveFile, '-struct', 'S','-append');
end

end