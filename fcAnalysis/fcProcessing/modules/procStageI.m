function [ stageIOutputs ] = procStageI(expFolder,spotRegexp,psfKern,varargin)
%PROCSTAGEI Summary of this function goes here
%   Detailed explanation goes here
% expFolder,'WhiteTTL',psfObj,'stageIFunc',@findSpotsStage1V2,'calibrationFile',camVarFile

%--parameters--------------------------------------------------------------
params.stageIFunc           = @findSpotsStage1V2;
params.doProcParallel       = true;
params.camVarFile           = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


spotFiles      = getAllFiles(expFolder,'tif');
spotFiles      = keepCertainStringsIntersection(spotFiles,spotRegexp);
spotFiles      = convertListToListofArguments(spotFiles);


stageIOutputs    = applyFuncTo_listOfListOfArguments(spotFiles,@openImage_applyFuncTo,{},params.stageIFunc,{psfKern,params.camVarFile,varargin{:}},@saveToProcessed_stageI,{},'doParallel',params.doProcParallel );

% spot_Thetas     = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{1}'});
% spot_A1s        = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{2}'});
% spot_LLRatios   = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{3}'});
% spot_A1s        = groupByTimeLapses(spot_A1s);
% spot_LLRatios   = groupByTimeLapses(spot_LLRatios);
% spot_Thetas     = groupByTimeLapses(spot_Thetas);
% spot_A1s        = convertListToListofArguments(spot_A1s);
% spot_LLRatios   = convertListToListofArguments(spot_LLRatios);
% spot_Thetas     = convertListToListofArguments(spot_Thetas);
saveFolder = strcat(expFolder,filesep,'processingState');
saveFolder = saveFolder{1};
makeDIR(saveFolder);
save(saveFolder,'stageIOutputs','-append');

end

