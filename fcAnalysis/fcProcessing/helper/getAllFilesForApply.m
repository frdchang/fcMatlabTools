function [ files ] = getAllFilesForApply(path,varargin )
%GETALLFILESFORAPPLY gets all files then converts it to list of list so
%applyfunc can work on it. 
path = escapeSpecialCharacters(path);
files = getAllFiles(path,varargin);
files = convertListToListofArguments(files);
end

