function [ qpmOutputs ] = procQPMs(phaseOutputs,varargin)
%PROCQPMS 

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

phaseFiles = phaseOutputs.outputFiles.files;
phaseFiles = convertListToListofArguments(phaseFiles);
qpmOutputs = applyFuncTo_listOfListOfArguments(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{varargin{:}},@saveToProcessed_images,{},params);

qpmOutputs = procSaver(phaseOutputs,qpmOutputs);

