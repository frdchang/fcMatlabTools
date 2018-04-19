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

% MLEs = stageIIOutputs.outputFiles.stageIIMLEs;
MLEs = loadTheSpots(stageIIOutputs.outputFiles.pathToStageIIMLEs);
MLEs = cellfunNonUniformOutput(@(x) MLEs(x),idxs);
MLEs = convertListToListofArguments(MLEs);
MLEsAndAlignments = glueCellArguments(MLEs,xyAlignDatas,{stageIIOutputs.outputFiles.pathToStageIIMLEs});


T_stageIIOutputs    = applyFuncTo_listOfListOfArguments(MLEsAndAlignments,@ openData_passThru,{},@translateSpots,{},@saveToProcessed_translateSpots,{},varargin{:});

T_stageIIOutputs = procSaver(stageIIOutputs,T_stageIIOutputs);
end

function spots = loadTheSpots(files)
spots = cell(numel(files),1);
for ii = 1:numel(files)
    temp = load(files{ii});
    spots{ii} = temp.stageIIMLEs;
end
end