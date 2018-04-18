function [ Trans_procOutput ] = procXYTranslate(xyAlignment,procOutput,varargin)
%PROCXYTRANSLATE Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel   = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% get alignment datas
procOutputOGName = inputname(2);
xyAlignDatas = xyAlignment.outputFiles.xyAlignment;
xyAlignDatas = convertListToListofArguments(xyAlignDatas);

% for every field that is a tif or fits do xy translation from seq
Trans_procOutput.inputFiles = table;
Trans_procOutput.outputFiles = table;
tableNames = procOutput.outputFiles.Properties.VariableNames;
for ii = 1:numel(tableNames)
    currEntry = procOutput.outputFiles.(tableNames{ii});
    if ~isIMGFile(currEntry)
       continue; 
    end
    if iscell(currEntry{1})
        cellOutput = {};
        numChans = numel(currEntry{1});
        for jj = 1:numChans
            currChan = grabFromListOfCells(currEntry,{['@(x) x{' num2str(jj) '}']});
            currChan = groupByTimeLapses(currChan);
            currChan = convertListToListofArguments(currChan);
            imgAndTransData = glueCellArguments(currChan,xyAlignDatas);
            cellOutput{end+1} = applyFuncTo_listOfListOfArguments(imgAndTransData,@openData_passThru,{},@translateSeq,{},@ saveToProcessed_translateSeq,{},varargin{:});
        end
        Trans_procOutput.inputFiles = horzcat(Trans_procOutput.inputFiles,table(currEntry,'VariableNames',tableNames(ii)));
        gluedOutputs = cellfunNonUniformOutput(@(x) x.outputFiles.translateSeq,cellOutput);
        gluedOutputs = cellfunNonUniformOutput(@convertListToListofArguments,gluedOutputs);
        gluedOutputs = glueCellArguments(gluedOutputs{:});

        Trans_procOutput.outputFiles = horzcat(Trans_procOutput.outputFiles,table({gluedOutputs{:}}','VariableNames',tableNames(ii)));
    else
        currEntrybyTime = groupByTimeLapses(currEntry);
        currEntryList = convertListToListofArguments(currEntrybyTime);
        imgAndTransData = glueCellArguments(currEntryList,xyAlignDatas);
        currOutput = applyFuncTo_listOfListOfArguments(imgAndTransData,@openData_passThru,{},@translateSeq,{params},@ saveToProcessed_translateSeq,{},varargin{:});
        Trans_procOutput.inputFiles = horzcat(Trans_procOutput.inputFiles, table(currEntry,'VariableNames',tableNames(ii)));
        Trans_procOutput.outputFiles = horzcat(Trans_procOutput.outputFiles, table(currOutput.outputFiles.translateSeq,'VariableNames',tableNames(ii)));
    end
end

TransName = ['T_' procOutputOGName];
Trans_procOutput = procSaver(procOutput,Trans_procOutput,TransName);
end

