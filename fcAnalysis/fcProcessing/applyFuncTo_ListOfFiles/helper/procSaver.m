function [] = procSaver(expFolder,outputVariable)
%PROCSAVER will save the variable at path

newName = inputname(2);
saveFile = strcat(expFolder,filesep,'processingState');
saveFile = [saveFile '.mat'];

S.(newName) = outputVariable;

if exist(saveFile,'file')==0
    save(saveFile, '-struct', 'S');
else
    save(saveFile, '-struct', 'S','-append');
end

end