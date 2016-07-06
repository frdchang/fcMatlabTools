function [] = doSpotDetectionOnDataSet(pathToGenDataFolder,varargin)
%ANALYZEDATASET Summary of this function goes here
%   Detailed explanation goes here

dataSetFiles = getAllFiles(pathToGenDataFolder,'A[0-9]+-B[0-9]+-[0-9]+.fits');
applyFuncTo_ListOfFiles(dataSetFiles,@openImage_applyFuncTo,{},@fcSpotDetection,varargin,@saveToProcessed_applyFuncTo,{});


end
