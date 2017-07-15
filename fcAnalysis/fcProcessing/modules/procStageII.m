function [ stageIIOutputs ] = procStageII(stageIOutputs,selectCands,varargin )
%PROCSTAGEII Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

dataFiles            = stageIOutputs.inputFiles;

camVarFile           = stageIOutputs.camVarFile;
camVarFile           = convertListToListofArguments({camVarFile});

stageIStructsFiles   = grabFromListOfCells(stageIOutputs.outputFiles,{['@(x) x{end}']});
stageIStructsFiles   = convertListToListofArguments(stageIStructsFiles);

selectCandsFiles     = selectCands.outputFiles;
selectCandsFiles     = convertListToListofArguments(selectCandsFiles);

stageIIArgFiles      = glueCellArguments(stageIStructsFiles,selectCandsFiles);

stageIIOutputs       = applyFuncTo_listOfListOfArguments(stageIIArgFiles,@openData_stageII,{},@findSpotsStage2V2,{varargin{:}},@saveToProcessed_findSpotsStage2V2,{},'doParallel',params.doProcParallel);



end

