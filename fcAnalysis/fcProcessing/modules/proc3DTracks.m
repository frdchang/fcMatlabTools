function [ gen3DTracks ] = proc3DTracks(eC_T_qpmOutputs,eC_T_stageIOutputs,trackedSpots,varargin)
%PROC3DTRACKS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

tracks      = trackedSpots.outputFiles.passThru;
LLRatios    = eC_T_stageIOutputs.outputFiles.LLRatio3;
qpms        = eC_T_qpmOutputs.outputFiles.genQPM1;

LLRatios    = convertTimeLapseOfCellsToCells(LLRatios);
qpms        = convertTimeLapseOfCellsToCells(qpms);

trackArgs   = glueCells(tracks,LLRatios,qpms);

gen3DTracks = applyFuncTo_listOfListOfArguments(trackArgs,@openData_passThru,{},@make3DTracks,{varargin{:}},@saveToProcessed_passThru,{},params);


end

