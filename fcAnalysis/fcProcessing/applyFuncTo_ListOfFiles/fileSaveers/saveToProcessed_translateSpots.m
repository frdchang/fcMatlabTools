function [ output ] = saveToProcessed_translateSpots( listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_TRANSLATESPOTS Summary of this function goes here
%   Detailed explanation goes here

output = funcOutput{1};
output = table({output},'VariableNames',{'stageIIMLEs'});
end

