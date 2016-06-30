function [] = analyzeDataSet(pathToGenDataFolder)
%ANALYZEDATASET Summary of this function goes here
%   Detailed explanation goes here

dataSetFiles = getAllFiles(pathToGenDataFolder,'A[0-9]+-B[0-9]+');
applyFuncTo_ListOfFiles(dataSetFiles,@openImage_applyFuncTo,{},@fcSpotDetection,params,@saveToProcessed_applyFuncTo,{});


