function [kymoViews] = procKymoViews(eC_T_stageIOutputs,ec_T_stageIIOutputs,varargin)
%PROCKYMOVIEWS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

A1s         = eC_T_stageIOutputs.outputFiles.A1;
% MLEs        = ec_T_stageIIOutputs.outputFiles.extractSpots;
MLEs = load(ec_T_stageIIOutputs.outputFiles.mat{1});
MLEs = {MLEs.extractSpots};
A1s = convertA1sToGlued(A1s);
MLEs        = convertTimeLapseOfCellsToCells(MLEs);

stageIstageIIQPMs = glueCells(A1s,MLEs);

kymoViews   = applyFuncTo_listOfListOfArguments(stageIstageIIQPMs,@openData_passThru,{},@makeKymo,{varargin{:},'units',ec_T_spotOutputs.units},@saveToProcessed_makeKymo,{},params);

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
