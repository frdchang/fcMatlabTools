function [ myImage ] = openData_stageI( varargin )
%OPENDATA_STAGEI Summary of this function goes here
%   Detailed explanation goes here
 myImage = {cellfunNonUniformOutput(@(x) importStack(x),varargin)};

end

