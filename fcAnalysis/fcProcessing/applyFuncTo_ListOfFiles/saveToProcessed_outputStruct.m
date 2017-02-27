function outputPath = saveToProcessed_outputStruct(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_FINDSPOTSSTAGE1V2 additional arguments select for subset
%of outputs
% 
% [0 1 0 0 1 1] = outputs A1, LLRatio_WLS,LLRatio_PoissPoiss,

outputStruct = funcOutput{1};
outputFields = fields(outputStruct);

if ~isempty(varargin)
    idxOutput = find(varargin{1}>0);
end

for ii = 1:numel(idxOutput)
   currOutput = getfield(outputStruct,outputFields{idxOutput(ii)});
   saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',outputFields{idxOutput(ii)});
   outputPath{ii} = saveProcessedFileAt;
   if isinteger(currOutput)
      exportSingleTifStack(saveProcessedFileAt,currOutput);
   else
      exportSingleFitsStack(saveProcessedFileAt,currOutput);
   end
end

% % save first func output
% saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',outputName);
% makeDIRforFilename(saveProcessedFileAt);
% output{1} = [saveProcessedFileAt '.mat'];
% spotParams = funcOutput{1};
% try
%     save(saveProcessedFileAt,'-v6','spotParams');
% catch
% end
% 
% outputName = ;
% saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',outputName);
% 
% makeDIRforFilename(saveProcessedFileAt);
% saveOutput = funcOutput{2}.A1;
% output{2} = exportStack(saveProcessedFileAt,saveOutput);
% 
% outputName = ;
% saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',outputName);
% makeDIRforFilename(saveProcessedFileAt);
% saveOutput = funcOutput{2}.LLRatio;
% output{3} = exportStack(saveProcessedFileAt,saveOutput);
% 
% outputName = ;
% 
% outputName = ;
% 
% outputName = ;

