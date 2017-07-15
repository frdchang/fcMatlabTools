function [ stageIIinputs ] = openData_stageII(varargin )
%OPENDATA_STAGEII Summary of this function goes here
%   Detailed explanation goes here

firstArg = load(varargin{1});
firstArg = firstArg.estimated;
secondArg = load(varargin{2});
secondArg = secondArg.funcOutput;
stageIIinputs{1} = firstArg;
stageIIinputs{2} = secondArg;
end

