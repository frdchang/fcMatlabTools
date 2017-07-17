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

qpmImagesbyTime       = groupByTimeLapses(qpmOutputs.outputFiles);
qpmImagesbyTime       = convertListToListofArguments(qpmImagesbyTime);

qpmOutputs.qpmImagesbyTime = qpmImagesbyTime;
qpmOutputs.expFolder = expFolder;
qpmOutputs.phaseRegexp = phaseRegexp;


saveFile = strcat(expFolder,filesep,'processingState');
saveFile = [saveFile '.mat'];

if exist(saveFile,'file')==0
    save(saveFile,'qpmOutputs');
else
    save(saveFile,'qpmOutputs','-append');
end

end

