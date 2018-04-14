function [ output ] = saveToProcessed_analyzeTracks(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_ANALYZETRACKS Summary of this function goes here
%   Detailed explanation goes here [ fullMontage,As,Bs,trackDists ]

saveFileArea = getFirstNonEmptyCellContent(cellflat(listOfFileInputPaths));
saveProcessedFileAt = genProcessedFileName(saveFileArea,myFunc,'paramHash',funcParamHash);

% save full montage as image
imgFile = [saveProcessedFileAt '.tif'];
makeDIRforFilename(imgFile);
imwrite(funcOutput{1},imgFile);

% save track stat as struct mat
trackStats.As = funcOutput{2};
trackStats.Bs = funcOutput{3};
trackStats.dists = funcOutput{4};

matFile = [saveProcessedFileAt '.mat'];
saveWithName(trackStats,matFile,'trackStats');

% save view tracks
saveProcessedFileAt = genProcessedFileName(saveFileArea,myFunc,'paramHash',funcParamHash,'appendFolder','views');
makeDIRforFilename(saveProcessedFileAt);
viewSeq = funcOutput{5};
numSeq = size(viewSeq{1},2);
numChan = numel(viewSeq);
myArg = cell(numChan,1);
seqFileHolder = cell(numSeq,1);
for ii = 1:numSeq
    for jj = 1:numChan
       myArg{jj} = viewSeq{jj}(:,ii); 
    end
   rgbCombinedView = combineViews(myArg{:});
   seqFileHolder{ii} = [saveProcessedFileAt '_t' num2str(ii) '.tif'];
   imwrite(rgbCombinedView,seqFileHolder{ii});
end

output = table({imgFile},{matFile},{seqFileHolder},'VariableNames',{'montage','mat','seqFiles'});

end

