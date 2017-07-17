function [ qpmOutputs ] = procQPMs(expFolder,phaseRegexp,varargin)
%PROCQPMS 

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

phaseFiles      = getAllFiles(expFolder,'tif');
phaseFiles      = keepCertainStringsIntersection(phaseFiles,phaseRegexp);

if isempty(phaseFiles)
   qpmOutputs = [];
   return;
end
phaseFiles      = convertListToListofArguments(phaseFiles);

qpmOutputs      = applyFuncTo_listOfListOfArguments(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{varargin{:}},@saveToProcessed_images,{},'doParallel',params.doProcParallel);

% append additional info
qpmOutputs.expFolder   = expFolder;
qpmOutputs.phaseRegexp = phaseRegexp;

procSaver(expFolder,qpmOutputs);

