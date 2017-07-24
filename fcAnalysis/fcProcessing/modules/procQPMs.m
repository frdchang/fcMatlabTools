function [ qpmOutputs ] = procQPMs(phaseOutputs,varargin)
%PROCQPMS 

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

phaseFiles = phaseOutputs.outputFiles.files;
phaseFiles = convertListToListofArguments(phaseFiles);
qpmOutputs = applyFuncTo_listOfListOfArguments(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{varargin{:}},@saveToProcessed_images,{},'doParallel',params.doProcParallel);

qpmOutputs = procSaver(phaseOutputs,qpmOutputs);

