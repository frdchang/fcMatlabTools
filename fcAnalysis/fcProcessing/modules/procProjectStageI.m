function [projFuncOutput] = procProjectStageI(stageIOutput,varargin )
%PROCAPPLYTOIMAGES Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.projFunc     = @maxColoredProj;
params.projFuncArg  = {3};
params.doProcParallel = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


allFiles = flattenTable(stageIOutput.outputFiles);
imageFiles = keepCertainStringsUnion(allFiles,{'tif','fits'});
imageFiles = convertListToListofArguments(imageFiles);

projFuncOutput    = applyFuncTo_listOfListOfArguments(imageFiles,@openImage_applyFuncTo,{},params.projFunc,{params.projFuncArg{:}},@saveToProcessed_images,{},'doParallel',params.doProcParallel);

procSaver(stageIOutput.expFolder,projFuncOutput,[func2str(params.projFunc) 's']);
end

