function [ stageIIOutputs ] = procStageII(stageIOutputs,selectCands,varargin )
%PROCSTAGEII Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
params.Kmatrix            = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

dataFiles            = stageIOutputs.inputFiles;

camVarFile           = stageIOutputs.camVarFile;
camVarFile           = convertListToListofArguments({camVarFile});

psfObj               = stageIOutputs.psfObj;
psfObj               = convertListToListofArguments({psfObj});

stageIStructsFiles   = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{end}'});
stageIStructsFiles   = convertListToListofArguments(stageIStructsFiles);

selectCandsFiles     = selectCands.outputFiles;
selectCandsFiles     = convertListToListofArguments(selectCandsFiles);

stageIIArgFiles      = glueCellArguments(dataFiles,camVarFile,stageIStructsFiles,selectCandsFiles,convertListToListofArguments({params.Kmatrix}),psfObj);

stageIIOutputs       = applyFuncTo_listOfListOfArguments(stageIIArgFiles,@openData_stageII,{},@findSpotsStage2V2,{varargin{:}},@saveToProcessed_findSpotsStage2V2,{},'doParallel',params.doProcParallel);



end

