function [ Trans_procOutput ] = procXYTranslate(xyAlignment,procOutput,varargin)
%PROCXYTRANSLATE Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel   = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

procOutputOGName = inputname(2);
xyAlignDatas = xyAlignment.outputFiles.xyAlignment;
xyAlignDatas = convertListToListofArguments(xyAlignDatas);

% for every field that is a tif or fits do xy translation from seq
tableNames = procOutput.outputFiles.Properties.VariableNames;
outputBasket = cell(numel(tableNames),1);
for ii = 1:numel(tableNames)
   currEntry = procOutput.outputFiles.(tableNames{ii}); 
   if iscell(currEntry{1})
       numChans = numel(currEntry{1});
       for jj = 1:numChans
           currChan = grabFromListOfCells(currEntry,{['@(x) x{' num2str(jj) '}']});
           currChan = groupByTimeLapses(currChan);
           currChan = convertListToListofArguments(currChan);
           test = applyFuncTo_listOfListOfArguments(glueCellArguments(currChan,xyAlignDatas),@openData_passThru,{},@translateSeq,{},@ saveToProcessed_passThru,{},'doParallel',params.doProcParallel);

       end
   else
       
   end
end

Trans_procOutput = applyFuncTo_listOfListOfArguments(glueCellArguments(qpmImages,alignXYs),@openData_passThru,{},@translateSeq,{},@ saveToProcessed_passThru,{},'doParallel',params.doProcParallel);
TransName = ['Trans_' procOutputOGName];
Trans_procOutput = procSaver(procOutput,Trans_procOutput,TransName);
end

