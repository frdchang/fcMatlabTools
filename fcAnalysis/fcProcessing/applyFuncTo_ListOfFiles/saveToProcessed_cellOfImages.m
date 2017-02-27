function [ output ] = saveToProcessed_cellOfImages(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_CELLOFIMAGES Summary of this function goes here
%   Detailed explanation goes here



cellListOfOutputFiles = funcOutput{1};

for ii = 1:numel(cellListOfOutputFiles)
    currImage = cellListOfOutputFiles{ii};

        outputFileName = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash,'appendFolder',num2str(ii));

    output{ii} = exportStack(outputFileName,currImage);
end

end

