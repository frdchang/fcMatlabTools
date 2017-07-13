function [ selectCands ] = procSelectCandidates(stageIOutputs,varargin )
%PROJSELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

stageIStructs   = grabFromListOfCells(stageIOutputs.outputFiles,{['@(x) x{end}']});
stageIStructs   = convertListToListofArguments(stageIStructs);

selectCands     = applyFuncTo_listOfListOfArguments(stageIStructs,@openData_load,{},@selectCandidates,{varargin{:}},@saveToProcessed_direct,{},'doParallel',params.doProcParallel);

end

