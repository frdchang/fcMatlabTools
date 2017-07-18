function [ selectCands ] = procSelectCandidates(stageIOutputs,varargin )
%PROJSELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
params.cellMasks          = [];
params.cellMaskVariable   = 'doOtsuThresh1';
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

stageIStructs   = stageIOutputs.outputFiles.mat;
stageIStructs   = convertListToListofArguments(stageIStructs);

% if there is a cell mask, punt it in
if ~isempty(params.cellMasks)
   cellMaskFiles = params.cellMasks.outputFiles.(params.cellMaskVariable);
   cellMaskFiles = convertListToListofArguments(cellMaskFiles);
   stageIStructs = glueCellArguments(stageIStructs,cellMaskFiles);
end

selectCands     = applyFuncTo_listOfListOfArguments(stageIStructs,@openData_selectCandidates,{},@selectCandidates,{varargin{:}},@saveToProcessed_selectCandidates,{},'doParallel',params.doProcParallel);

expFolder = stageIOutputs.expFolder;
procSaver(expFolder,selectCands);

end

