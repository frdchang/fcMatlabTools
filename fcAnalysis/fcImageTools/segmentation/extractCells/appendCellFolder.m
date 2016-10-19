function cellPath = appendCellFolder(saveProcessedFileAt,cellnum)
%APPENDCELLFOLDER will update processed file path to have a cell
[myPath,myFile,myExt] = fileparts(saveProcessedFileAt);
myFile = regexprep(myFile,'extractCell',['extractCell' num2str(cellnum)]);
saveProcessedFileAt = [myPath filesep myFile myExt];
splitAtExtractCell = regexp(saveProcessedFileAt,'\[extractCell\]','split');
cellPath = [splitAtExtractCell{1} '[extractCell]' filesep 'cell' num2str(cellnum) splitAtExtractCell{2}];

end

