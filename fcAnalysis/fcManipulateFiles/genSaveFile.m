function pathToFileName = genSaveFile(path,filename,varargin)
%GENSAVEFILE will make sure directory structure exists and if not, will
%make it to filename

pathToFileName = [path filesep filename];
makeDIRforFilename(pathToFileName);



end

