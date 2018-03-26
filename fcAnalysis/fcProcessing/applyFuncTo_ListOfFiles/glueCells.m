function [ glued ] = glueCells( varargin )
%GLUECELLS similar to glue cell arguments but converst the list ot a list
%as inthe input
inputs = cellfunNonUniformOutput(@convertListToListofArguments,varargin);
glued= glueCellArguments(inputs{:});
end

