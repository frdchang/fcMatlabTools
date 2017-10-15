function [ output_args ] = procVizSpots(eC_T_stageIOutputs,ec_T_stageIIOutputs,varargin)
%PROCVIZSPOTS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

A1s         = eC_T_stageIOutputs.outputFiles.A1;
MLEs        = ec_T_stageIIOutputs.outputFiles.extractSpots;

A1s = convertA1sToGlued(A1s);

MLEs        = convertTimeLapseOfCellsToCells(MLEs);

A1sAndMLES = glueCells(A1s,MLEs);

ec_T_3Dviz   = applyFuncTo_listOfListOfArguments(A1sAndMLES,@openData_passThru,{},@vizSpots,{varargin{:}},@saveToProcessed_vizSpots,{},params);

end

function glued = convertA1sToGlued(A1s)
A1s         = cellfunNonUniformOutput(@localGlue,A1s{:});
glued = glueChans(A1s);
end

function glued = glueChans(A1s)
glued = cellfunNonUniformOutput(@glueCells,A1s{:});
end

function converted = reorder(converted)
converted = mat2cell(converted,ones(size(converted,2),1));
end

function converted = convertTimeLapseOfCellsToCells(myList)
converted = cat(1,myList{:});
end

function output = localGlue(varargin)
output = cat(1,varargin{:});
end