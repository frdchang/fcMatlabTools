function [ outputs ] = saveToProcessed_translateSeq(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_TRANSLATESEQ Summary of this function goes here
%   Detailed explanation goes here


% saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths{1},myFunc,'paramHash',funcParamHash);
% saveProcessedFileAt = [saveProcessedFileAt '.mat'];


outputs = table({funcOutput{1}},'VariableName',{'translateSeq'});
end

