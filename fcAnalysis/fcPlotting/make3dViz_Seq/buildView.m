function [ outputViews ] = buildView(listOfFiles,upRezFactor)
%BUILDVIEW will make the 3d projection views
if isempty(listOfFiles)
   views = [];
   return;
end
numSeq = numel(listOfFiles);

firstFile = getFirstNonEmptyCellContent(listOfFiles);
currFluor = importStack(firstFile);
sizeDatas  = size(currFluor{1});
upRezFactor = upRezFactor(1:numel(sizeDatas));

numViews = ceil(numSeq/sizeDatas(2));

views = cell(numel(listOfFiles{1}),1);
timepoints = cell(3,numViews);
[views{:}] = deal(timepoints);
idx = linspace(1,numSeq,numViews);
for ii = 1:numel(idx)
    currFluor = importStack(listOfFiles{ii});
    currFluor = cellfunNonUniformOutput(@(x) myIMResize(x,upRezFactor.*size(x),'nearest'),currFluor);
    if ~isempty(currFluor)
        for jj = 1:numel(currFluor)
            currStack = currFluor{jj};
            [~,theViews] = return3Views(currStack);
             views{jj}{1,ii} = theViews.view1(:,:,1);
             views{jj}{2,ii} = theViews.view2(:,:,1);
             views{jj}{3,ii} = theViews.view3(:,:,1);
        end
    end
end

outputViews = cell(numel(listOfFiles{1}),1);
timepoints = cell(3,1);
[outputViews{:}] = deal(timepoints);
for ii = 1:numel(views)
   outputViews{ii}{1} = [views{ii}{1,:}]; 
   outputViews{ii}{2} = [views{ii}{2,:}]; 
   outputViews{ii}{3} = [views{ii}{3,:}]; 
end
outputViews = ncellfun(@norm2UINT255,views);
end

