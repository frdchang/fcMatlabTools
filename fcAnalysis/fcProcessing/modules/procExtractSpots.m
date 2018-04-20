function [ ec_T_stageIIOutputs ] = procExtractSpots( T_yeastSegs,T_stageIIOutputs,varargin)
%PROCEXTRACTSPOTS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel   = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% get segmentation data
segData = T_yeastSegs.outputFiles.mat;
segData = convertListToListofArguments(segData);
% for every field that is a tif or fits do xy translation from seq
ec_T_stageIIOutputs.inputFiles = table;
ec_T_stageIIOutputs.outputFiles = table;

currEntry =  load(T_stageIIOutputs.outputFiles.xy_stageIIMLEs{1});
currEntry = currEntry.funcOutput;
currEntry = convertListToListofArguments(currEntry);

MLEsAndSegData = glueCellArguments(currEntry,segData);
ec_T_stageIIOutputs =  applyFuncTo_listOfListOfArguments(MLEsAndSegData,@openData_passThru,{},@extractSpots,{},@saveToProcessed_extractSpots,{},'doParallel',params.doProcParallel);
ec_T_stageIIOutputs = procSaver(T_yeastSegs,ec_T_stageIIOutputs);
end

