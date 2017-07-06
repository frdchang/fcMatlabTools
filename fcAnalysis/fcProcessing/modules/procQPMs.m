function [ qpmOutputs ] = procQPMs(expFolder,phaseRegexp,varargin)
%PROCQPMS 

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

phaseFiles      = getAllFiles(expFolder,'tif');
phaseFiles      = keepCertainStringsIntersection(phaseFiles,phaseRegexp);

phaseFiles      = convertListToListofArguments(phaseFiles);
qpmOutputs      = applyFuncTo_listOfListOfArguments(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{varargin{:}},@saveToProcessed_images,{},'doParallel',params.doProcParallel);

qpmImages       = groupByTimeLapses(processQPM.outputFiles);
qpmImages       = convertListToListofArguments(qpmImages);
qpmOutputs.qpmImages = qpmImages;

save([expFolder filesep 'processingState'],'-append');
end

