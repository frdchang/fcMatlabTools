function [ eC_T_procOutputs ] = procExtractCells(T_yeastSegs,procOutputs,varargin)
%PROCEXTRACTCELLS Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel   = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% get segmentation data
segData = T_yeastSegs.outputFiles.mat;
segData = convertListToListofArguments(segData);
% for every field that is a tif or fits do xy translation from seq
eC_T_procOutputs.inputFiles = table;
eC_T_procOutputs.outputFiles = table;
tableNames = procOutputs.outputFiles.Properties.VariableNames;
for ii = 1:numel(tableNames)
    currEntry = procOutputs.outputFiles.(tableNames{ii});
    if ~isIMGFile(currEntry)
        continue;
    end
    currEntry = convertListToListofArguments(currEntry);
    imgAndSegData = glueCellArguments(currEntry,segData);
    currOutput =  applyFuncTo_listOfListOfArguments(imgAndSegData,@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},varargin{:});
    eC_T_procOutputs.inputFiles = horzcat(eC_T_procOutputs.inputFiles,table(imgAndSegData,'VariableNames',tableNames(ii)));
    eC_T_procOutputs.outputFiles = horzcat(eC_T_procOutputs.outputFiles,table(currOutput.outputFiles.passThru,'VariableNames',tableNames(ii)));
end
procOutputOGName = inputname(2);
TransName = ['eC_' procOutputOGName];
eC_T_procOutputs = procSaver(T_yeastSegs,eC_T_procOutputs,'newName',TransName);
end

