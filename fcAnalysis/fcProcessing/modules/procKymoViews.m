function [kymoViews] = procKymoViews(eC_T_stageIOutputs,eC_T_spotOutputs,varargin)
%PROCKYMOVIEWS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

A1s         = eC_T_stageIOutputs.outputFiles.A1;
A1s = convertA1sToGlued(A1s);
stageIstageIIQPMs = glueCells(A1s);

kymoViews   = applyFuncTo_listOfListOfArguments(stageIstageIIQPMs,@openData_passThru,{},@makeKymo,{varargin{:},'units',eC_T_spotOutputs.units},@saveToProcessed_makeKymo,{},params);

kymoViews   = procSaver(eC_T_stageIOutputs,kymoViews);
end

function glued = convertA1sToGlued(A1s)
A1s         = cellfunNonUniformOutput(@localGlue,A1s{:});
glued = glueChans(A1s);
end

function glued = glueChans(A1s)
glued = cellfunNonUniformOutput(@glueCells,A1s{:});
end


function converted = convertTimeLapseOfCellsToCells(myList)
converted = cat(1,myList{:});
end

function output = localGlue(varargin)
output = cat(1,varargin{:});
end
