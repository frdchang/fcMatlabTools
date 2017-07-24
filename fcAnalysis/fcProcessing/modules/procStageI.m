function [ stageIOutputs ] = procStageI(spotOutputs,psfObj,varargin)
%PROCSTAGEI Summary of this function goes here
%   Detailed explanation goes here
% expFolder,'WhiteTTL',psfObj,'stageIFunc',@findSpotsStage1V2,'calibrationFile',camVarFile

%--parameters--------------------------------------------------------------
params.stageIFunc           = @findSpotsStage1V2;
params.doProcParallel       = true;
params.camVarFile           = [];
params.Kmatrix              = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


spotFileInputs = spotOutputs.outputFiles.files;
% spotFiles      = convertListToListofArguments(spotFiles);


stageIOutputs    = applyFuncTo_listOfListOfArguments(spotFileInputs,@ openData_stageI,{},params.stageIFunc,{cellfunNonUniformOutput(@(x) x.returnShape,psfObj),params.camVarFile,'kMatrix',params.Kmatrix,varargin{:}},@saveToProcessed_stageI,{},'doParallel',params.doProcParallel );

% spot_Thetas     = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{1}'});
% spot_A1s        = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{2}'});
% spot_LLRatios   = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{3}'});
% spot_A1s        = groupByTimeLapses(spot_A1s);
% spot_LLRatios   = groupByTimeLapses(spot_LLRatios);
% spot_Thetas     = groupByTimeLapses(spot_Thetas);
% spot_A1s        = convertListToListofArguments(spot_A1s);
% spot_LLRatios   = convertListToListofArguments(spot_LLRatios);
% spot_Thetas     = convertListToListofArguments(spot_Thetas);

stageIOutputs.psfObj     = psfObj;
stageIOutputs.camVarFile = params.camVarFile;
stageIOutputs.Kmatrix    = params.Kmatrix;
stageIOutputs = procSaver(spotOutputs,stageIOutputs);

