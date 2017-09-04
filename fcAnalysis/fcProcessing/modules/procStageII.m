function [ stageIIOutputs ] = procStageII(stageIOutputs,selectCands,varargin )
%PROCSTAGEII Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
params.doParallel         = false;
params.doPlotEveryN       = inf;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

dataFiles            = stageIOutputs.inputFiles.spotFileInputs;
dataFiles            = convertListToListofArguments(dataFiles);

camVarFile           = stageIOutputs.camVarFile;
camVarFile           = convertListToListofArguments({camVarFile});

psfObj               = stageIOutputs.psfObj;
psfObj               = convertListToListofArguments({psfObj});

stageIStructsFiles   = stageIOutputs.outputFiles.mat;
stageIStructsFiles   = convertListToListofArguments(stageIStructsFiles);

selectCandsFiles     = selectCands.outputFiles.mat;
selectCandsFiles     = convertListToListofArguments(selectCandsFiles);

stageIIArgFiles      = glueCellArguments(dataFiles,camVarFile,stageIStructsFiles,selectCandsFiles,convertListToListofArguments({stageIOutputs.Kmatrix}),psfObj);

stageIIOutputs       = applyFuncTo_listOfListOfArguments(stageIIArgFiles,@openData_stageII,{},@findSpotsStage2V2,{params},@saveToProcessed_findSpotsStage2V2,{},varargin{:});

stageIIOutputs       = procSaver(stageIOutputs,stageIIOutputs);


end

