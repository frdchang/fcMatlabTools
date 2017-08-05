function [ output ] = saveToProcessed_make3DViz_Seq(  listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin  )
%SAVETOPROCESSED_MAKE3DVIZ_SEQ Summary of this function goes here
%   Detailed explanation goes here

firstFiles = calcConsensusString(flattenCellArray(listOfFileInputPaths{1}));
saveProcessedFileAt = genProcessedFileName(firstFiles,myFunc,'paramHash',funcParamHash);

saveProcessedFileAt = [saveProcessedFileAt '.tif'];
makeDIRforFilename(saveProcessedFileAt);
imwrite(funcOutput{1},saveProcessedFileAt);

output = table({saveProcessedFileAt},'VariableNames',{'montage'});
end

