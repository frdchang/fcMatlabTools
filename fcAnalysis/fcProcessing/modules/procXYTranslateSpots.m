function [ T_StageIIOutputs ] = procXYTranslateSpots(xyAlignments,stageIIOutputs )
%PROCXYTRANSLATESPOTS Summary of this function goes here
%   Detailed explanation goes here

% get alignment datas
xyAlignDatas = xyAlignments.outputFiles.xyAlignment;
xyAlignDatas = convertListToListofArguments(xyAlignDatas);

% create timelapse order for stage ii outputs
[~,idxs] = groupByTimeLapses( stageIIOutputs.outputFiles.pathToStageIIMLEs);

MLEs = stageIIOutputs.outputFiles.stageIIMLEs;
MLEs = cellfunNonUniformOutput(@(x) MLEs(x{:}),idxs);
end

