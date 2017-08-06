function [ trackedSpots ] = procSpotTracking(ec_T_stageIIOutputs,varargin )
%PROCSPOTTRACKING Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

MLEs = ec_T_stageIIOutputs.outputFiles.extractSpots;
MLEsByCells = cat(1,MLEs{:});
MLEsByCells = convertListToListofArguments(MLEsByCells);
trackedSpots   = applyFuncTo_listOfListOfArguments(MLEsByCells,@openData_passThru,{},@spotTracking3D,{varargin{:}},@saveToProcessed_spotTracking3D,{},'doParallel',params.doProcParallel);

trackedSpots = procSaver(ec_T_stageIIOutputs,trackedSpots);

end

