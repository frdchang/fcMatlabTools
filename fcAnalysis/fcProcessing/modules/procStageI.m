function [ stageIOutputs ] = procStageI(expFolder,spotRegexp,psfObj,varargin)
%PROCSTAGEI Summary of this function goes here
%   Detailed explanation goes here
% expFolder,'WhiteTTL',psfObj,'stageIFunc',@findSpotsStage1V2,'calibrationFile',camVarFile

%--parameters--------------------------------------------------------------
params.stageIFunc           = @findSpotsStage1V2;
params.doProcParallel       = true;
params.camVarFile           = [];
params.Kmatrix              = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


spotFiles      = getAllFiles(expFolder,'tif');
spotFiles      = cellfunNonUniformOutput(@(x) keepCertainStringsIntersection(spotFiles,x),spotRegexp);
pairedColoredFiles = cell(numel(spotFiles{1}),1);
for ii = 1:numel(spotFiles{1})
    pairedColoredFiles{ii} = cellfun(@(x) x(ii),spotFiles);
end
% spotFiles      = convertListToListofArguments(spotFiles);


stageIOutputs    = applyFuncTo_listOfListOfArguments(pairedColoredFiles,@openImage_applyFuncTo,{},params.stageIFunc,{cellfunNonUniformOutput(@(x) x.returnShape,psfObj),params.camVarFile,'kMatrix',params.Kmatrix,varargin{:}},@saveToProcessed_stageI,{},'doParallel',params.doProcParallel );

% spot_Thetas     = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{1}'});
% spot_A1s        = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{2}'});
% spot_LLRatios   = grabFromListOfCells(stageIOutputs.outputFiles,{'@(x) x{3}'});
% spot_A1s        = groupByTimeLapses(spot_A1s);
% spot_LLRatios   = groupByTimeLapses(spot_LLRatios);
% spot_Thetas     = groupByTimeLapses(spot_Thetas);
% spot_A1s        = convertListToListofArguments(spot_A1s);
% spot_LLRatios   = convertListToListofArguments(spot_LLRatios);
% spot_Thetas     = convertListToListofArguments(spot_Thetas);

stageIOutputs.expFolder = expFolder;
stageIOutputs.psfObj    = psfObj;
stageIOutputs.camVarFile = params.camVarFile;
saveFile = strcat(expFolder,filesep,'processingState');
saveFile = [saveFile '.mat'];

if exist(saveFile,'file')==0
    save(saveFile,'stageIOutputs');
else
    save(saveFile,'stageIOutputs','-append');
end

end

