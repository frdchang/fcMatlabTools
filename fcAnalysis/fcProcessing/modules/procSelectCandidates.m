function [ selectCands ] = procSelectCandidates(stageIOutputs,thresholdOutputs,varargin )
%PROJSELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
params.cellMasks          = [];
params.cellMaskVariable   = 'doOtsuThresh1';
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

stageIStructs   = stageIOutputs.outputFiles.mat;

thresholds      = num2cell(thresholdOutputs.outputFilesFlattened);
stageIandThresholds = glueCells(stageIStructs,thresholds);
% if there is a cell mask, punt it in
if ~isempty(params.cellMasks)
   cellMaskFiles = params.cellMasks.outputFiles.(params.cellMaskVariable);
   stageIandThresholds = glueCells(stageIStructs,cellMaskFiles,thresholds);
end

selectCands     = applyFuncTo_listOfListOfArguments(stageIandThresholds,@openData_selectCandidates,{},@selectCandidates,{varargin{:}},@saveToProcessed_selectCandidates,{},'doParallel',params.doProcParallel);


selectCands = procSaver(stageIOutputs,selectCands);

end

