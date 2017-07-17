function [  ] = saveWithName(variable,path,varargin)
%PROCSAVER will save the variable at path
newName = inputname(1);
S.(newName) = variable;
save(path, '-struct', 'S',varargin{:});
