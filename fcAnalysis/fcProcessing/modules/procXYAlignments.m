function xyAlignments = procXYAlignments( procOutputs,varargin)
%PROCALIGNMENTS Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.imgTableName     = 'genQPM1';
params.doProcParallel   = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

imgFiles = procOutputs.outputFiles.(params.imgTableName);
imgFiles = groupByTimeLapses(imgFiles);
imgFiles = convertListToListofArguments(imgFiles);

xyAlignments   = applyFuncTo_listOfListOfArguments(imgFiles,@openData_passThru,{},@stageAlign,{},@saveToProcessed_stageAlign,{},'doParallel',params.doProcParallel);

xyAlignments = procSaver(procOutputs,xyAlignments);
end

