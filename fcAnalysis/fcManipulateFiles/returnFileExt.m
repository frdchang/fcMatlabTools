function [ myext ] = returnFileExt( file )
%RETURNFILEEXT Summary of this function goes here
%   Detailed explanation goes here

[~,~,myext] = fileparts(file);
end

