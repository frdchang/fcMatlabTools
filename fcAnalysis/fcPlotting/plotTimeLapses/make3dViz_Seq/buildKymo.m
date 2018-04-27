function [ kymoXYZ ] = buildKymo(listOfFiles,upRezFactor)
%BUILDKYMO Summary of this function goes here
%   Detailed explanation goes here

if isempty(listOfFiles)
   kymoXYZ = [];
   return;
end
numSeq = numel(listOfFiles);

firstFile = getFirstNonEmptyCellContent(listOfFiles);
currFluor = importStack(firstFile);
sizeDatas  = size(currFluor{1});
upRezFactor = upRezFactor(1:numel(sizeDatas));
kymoXYZ = cell(numel(listOfFiles{1}),1);
kymos = arrayfun(@(x,y) zeros(x*y,numSeq),sizeDatas,upRezFactor,'UniformOutput',false);
[kymoXYZ{:}] = deal(kymos);

for ii = 1:numSeq
    currFluor = importStack(listOfFiles{ii});
    currFluor = cellfunNonUniformOutput(@(x) myIMResize(x,upRezFactor.*size(x),'nearest'),currFluor);
    if ~isempty(currFluor)
        for jj = 1:numel(currFluor)
            currStack = currFluor{jj};
            currStackXY = max(currStack,[],3);
            currStackZ  = max(max(currStack,[],1),[],2);
            kymoXYZ{jj}{1}(:,ii) = max(currStackXY,[],2);
            kymoXYZ{jj}{2}(:,ii) = max(currStackXY,[],1);
            kymoXYZ{jj}{3}(:,ii) = currStackZ;
        end
    end
end

 kymoXYZ = ncellfun(@norm2UINT255,kymoXYZ);
end

