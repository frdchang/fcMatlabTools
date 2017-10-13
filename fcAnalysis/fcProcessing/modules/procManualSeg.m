function [ T_yeastSegs ] = procManualSeg(segmentThis,varargin)
%PROCMANUALSEG Summary of this function goes here
%   Detailed explanation goes here

%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel       = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

switch inputname(1)
    case 'T_xyMaxProjNDs'
        files = cellfunNonUniformOutput(@(x) x{1},segmentThis.outputFiles.A1);
    otherwise
    error('i did not handle this case yet');     
end
files = {files};
T_yeastSegs     = applyFuncTo_listOfListOfArguments(files,@ openData_passThru,{},@manualSeg,{varargin{:}},@saveToProcessed_yeastSeg,{},varargin{:});
T_yeastSegs     = procSaver(segmentThis,T_yeastSegs);
end

