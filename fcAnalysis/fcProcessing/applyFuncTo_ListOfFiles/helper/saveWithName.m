function [  ] = saveWithName(variable,path,name)
%PROCSAVER will save the variable at path

makeDIRforFilename(path);
S.(name) = variable;
save(path, '-struct', 'S');
