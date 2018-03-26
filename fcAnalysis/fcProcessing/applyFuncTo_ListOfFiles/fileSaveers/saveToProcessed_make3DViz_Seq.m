function [ output ] = saveToProcessed_make3DViz_Seq(  listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin  )
%SAVETOPROCESSED_MAKE3DVIZ_SEQ Summary of this function goes here
%   Detailed explanation goes here

firstFiles = calcConsensusString(flattenCellArray(listOfFileInputPaths{1}));
saveProcessedFileAt = genProcessedFileName(firstFiles,myFunc,'paramHash',funcParamHash);

fullMontageFilePath = [saveProcessedFileAt '.tif'];
makeDIRforFilename(fullMontageFilePath);
imwrite(funcOutput{1},fullMontageFilePath);

matFilePath = [saveProcessedFileAt '.mat'];
saveWithName(funcOutput{2},matFilePath,'montagePieces');
output = table({fullMontageFilePath},{matFilePath},'VariableNames',{'montage','montagePiecesMat'});
end

