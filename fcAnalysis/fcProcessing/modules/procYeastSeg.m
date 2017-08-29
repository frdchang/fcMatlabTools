function [ T_yeastSegs ] = procYeastSeg(T_phaseOutputs,T_qpmOutputs,T_edgeProfileZs,varargin)
%PROCYEASTSEG Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.doProcParallel       = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

qpms            = T_qpmOutputs.outputFiles.genQPM1;
edgeProfiles    = T_edgeProfileZs.outputFiles.edgeProfileZ;
phases          = T_phaseOutputs.outputFiles.files;

finalQpms       = cellfunNonUniformOutput(@(x) importStack(x{end}),qpms);
finalPhases     = cellfunNonUniformOutput(@(x) importStack(x{end}),phases);

finalLs         = cellfunNonUniformOutput(@(finalPhases,finalQpms,edgeProfiles) segBrightZStack(finalPhases,finalQpms,'edgeProfileZ',edgeProfiles),finalPhases,finalQpms,edgeProfiles');
finalLs         = convertListToListofArguments(finalLs);

yeastSegInputs  = glueCellArguments(convertListToListofArguments(qpms),finalLs);
T_yeastSegs     = applyFuncTo_listOfListOfArguments(yeastSegInputs,@ openData_passThru,{},@trackingYeast,{varargin{:}},@saveToProcessed_yeastSeg,{},'doParallel',params.doProcParallel );
T_yeastSegs     = procSaver(T_phaseOutputs,T_yeastSegs);
end

