function [ ec_T_3Dviz ] = proc3DViz(eC_T_stageIOutputs,ec_T_stageIIOutputs,eC_T_qpmOutputs,varargin)
%PROC3DVIZ Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


A1s         = eC_T_stageIOutputs.outputFiles.A1;
LLRatios    = eC_T_stageIOutputs.outputFiles.LLRatio;
MLEs        = ec_T_stageIIOutputs.outputFiles.extractSpots;
qpms        = eC_T_qpmOutputs.outputFiles.genQPM1;



A1s         = cellfunNonUniformOutput(@convertTimeLapseOfCellsToCells,A1s);
A1s         = cellfunNonUniformOutput(@localGlue,A1s{:})
LLRatios    = convertTimeLapseOfCellsToCells(LLRatios);
MLEs        = convertTimeLapseOfCellsToCells(MLEs);
qpms        = convertTimeLapseOfCellsToCells(qpms);

A1s = convertListToListofArguments(A1s);
LLRatios = convertListToListofArguments(LLRatios);
MLEs = convertListToListofArguments(MLEs);
qpms = convertListToListofArguments(qpms);


stageIstageIIQPMs = glueCellArguments(A1s,MLEs,qpms,LLRatios);

ec_T_3Dviz   = applyFuncTo_listOfListOfArguments(stageIstageIIQPMs,@openData_passThru,{},@make3DViz_Seq,{},@saveToProcessed_passThru,{},'doParallel',params.doProcParallel);

end

function converted = convertTimeLapseOfCellsToCells(myList)
converted = cat(1,myList{:});
end

function output = localGlue(varargin)
output = cat(2,varargin{:});
end