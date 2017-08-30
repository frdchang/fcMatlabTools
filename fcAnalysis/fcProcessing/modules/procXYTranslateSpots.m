function [ T_stageIIOutputs ] = procXYTranslateSpots(xyAlignments,stageIIOutputs,varargin)
%PROCXYTRANSLATESPOTS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel       = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
% get alignment datas
xyAlignDatas = xyAlignments.outputFiles.xyAlignment;
xyAlignDatas = convertListToListofArguments(xyAlignDatas);

% create timelapse order for stage ii outputs
[~,idxs] = groupByTimeLapses( stageIIOutputs.outputFiles.pathToStageIIMLEs);

MLEs = stageIIOutputs.outputFiles.stageIIMLEs;
MLEs = cellfunNonUniformOutput(@(x) MLEs(x),idxs);
MLEs = convertListToListofArguments(MLEs);
MLEsAndAlignments = glueCellArguments(MLEs,xyAlignDatas);


T_stageIIOutputs    = applyFuncTo_listOfListOfArguments(MLEsAndAlignments,@ openData_passThru,{},@translateSpots,{},@saveToProcessed_translateSpots,{},params);

T_stageIIOutputs = procSaver(stageIIOutputs,T_stageIIOutputs);
end

