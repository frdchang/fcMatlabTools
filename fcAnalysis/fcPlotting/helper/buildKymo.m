function [ kymoXYZ ] = buildKymo(listOfFiles)
%BUILDKYMO Summary of this function goes here
%   Detailed explanation goes here

numSeq = numel(listOfFiles);

firstFile = getFirstNonEmptyCellContent(listOfFiles);
currFluor = importStack(firstFile);
sizeDatas  = size(currFluor{1});

kymoXYZ = cell(numel(listOfFiles{1}),1);
kymos = arrayfun(@(x) zeros(x,numSeq),sizeDatas,'UniformOutput',false);
[kymoXYZ{:}] = deal(kymos);

for ii = 1:numSeq
    currFluor = importStack(listOfFiles{ii});
    if ~isempty(currFluor)
        for jj = 1:numel(currFluor)
            currStack = currFluor{jj};
            currStackXY = maxintensityproj(currStack,3);
            currStackZ  = maxintensityproj(maxintensityproj(currStack,1),2);
            kymoXYZ{jj}{1}(:,ii) = maxintensityproj(currStackXY,2);
            kymoXYZ{jj}{2}(:,ii) = maxintensityproj(currStackXY,1);
            kymoXYZ{jj}{3}(:,ii) = currStackZ;
        end
    end
end
