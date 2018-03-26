function [ myPath ] = getPathFromFunc()
%GETPATHFROMFUNC Summary of this function goes here
%   Detailed explanation goes here
% p = mfilename('fullpath');
% [path,filename,ext] = fileparts(p);
% path = regexp(path,'(?:(?!fcAnalysis).)*','match');
% path = path{1};
% myPath = {[path 'fcAnalysis'],[path 'fcSpotDetectionV2']};

myPath = path;
myPath = strsplit(myPath,':');
myPath = keepCertainStringsUnion(myPath,'fcMatlabTools');
end

