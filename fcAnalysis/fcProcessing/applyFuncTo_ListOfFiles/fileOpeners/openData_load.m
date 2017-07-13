function [ data ] = openData_load( filepath,varargin )
%OPENDATA_LOAD Summary of this function goes here
%   Detailed explanation goes here

data = {loadAndTakeFirstField(filepath)};
end

