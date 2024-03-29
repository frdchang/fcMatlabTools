function [ cellMasks ] = procThreshPhase(qpmOutputs,varargin )
%PROCTHRESHPHASE Summary of this function goes here
%   Detailed explanation goes here

 
%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
params.phaseTableName     = 'genQPM1';
params.thresholdFunc      = @genMaskWOtsu;
params.thresholdFuncArg   = {};
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

phaseFiles = qpmOutputs.outputFiles.(params.phaseTableName);
phaseFiles = convertListToListofArguments(phaseFiles);

cellMasks = applyFuncTo_listOfListOfArguments(phaseFiles,@openImage_applyFuncTo,{},params.thresholdFunc,{params.thresholdFuncArg{:}},@saveToProcessed_images,{},varargin{:});
cellMasks = procSaver(qpmOutputs,cellMasks);
end

