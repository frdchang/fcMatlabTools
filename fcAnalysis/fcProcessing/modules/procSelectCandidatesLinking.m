function [ selectCands ] = procSelectCandidatesLinking(stageIOutputs,thresholdOutputs,varargin )
%PROCSELECTCANDIDATESLINKING Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
params.cellMasks          = [];
params.cellMaskVariable   = 'doOtsuThresh1';
params.myFunc             = @selectCandidatesLinking;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

stageIStructs   = {stageIOutputs.outputFiles.mat};
thresholds      = thresholdOutputs.outputFiles.thresholds;

stageIandThresholds = glueCells(stageIStructs,thresholds);

% if there is a cell mask, put it in
if ~isempty(params.cellMasks)
   cellMaskFiles = {params.cellMasks.outputFiles.(params.cellMaskVariable)};
   stageIandThresholds = glueCells(stageIStructs,cellMaskFiles,thresholds);
end

selectCands     = applyFuncTo_listOfListOfArguments(stageIandThresholds,@openData_selectCandidatesLinking,{},params.myFunc,{varargin{:}},@saveToProcessed_selectCandidatesLinking,{},varargin);


selectCands = procSaver(stageIOutputs,selectCands);

end


