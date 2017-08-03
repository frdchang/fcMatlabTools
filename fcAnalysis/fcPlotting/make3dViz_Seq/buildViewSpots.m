function [ outputViews ] = buildViewSpots(listOfFiles,spotParamsPaths,upRezFactor,varargin)
%BUILDVIEWSPOTS Summary of this function goes here
%   Detailed explanation goes here

if isempty(listOfFiles)
   viewSpots = [];
   return;
end
numSeq = numel(listOfFiles);

firstFile = getFirstNonEmptyCellContent(listOfFiles);
currFluor = importStack(firstFile);
sizeDatas  = size(currFluor{1});
upRezFactor = upRezFactor(1:numel(sizeDatas));

numViews = ceil(numSeq/sizeDatas(2));

viewSpots = cell(numel(listOfFiles{1}),1);
timepoints = cell(3,numViews);
temp = myIMResize(zeros(sizeDatas),upRezFactor.*sizeDatas,'nearest');
for ii = 1:numViews
   timepoints{1,ii} = maxintensityproj(temp,3);
   timepoints{2,ii} = maxintensityproj(temp,2);
   timepoints{3,ii} = maxintensityproj(temp,1)';
end

[viewSpots{:}] = deal(timepoints);
idx = linspace(1,numSeq,numViews);
for ii = 1:numel(idx)
    if ~isempty(spotParamsPaths{ii})
        % for each spot
        for jj = 1:numel(spotParamsPaths{ii})
            currSpot = spotParamsPaths{ii}{jj};
            selectedSpot = spotSelectorByThresh(currSpot,varargin{:});
            selectedMLESingleSpot = selectedSpot.thetaMLEs;
            [~,singleSpotTheta,~] =  getSpotCoorsFromTheta(selectedMLESingleSpot);
            currStacks   = cellfunNonUniformOutput(@(x) genSpotIMG(x,sizeDatas,upRezFactor),singleSpotTheta);
            for kk = 1:numel(currStacks)
                viewSpots{kk}{1,ii} = viewSpots{kk}{1,ii} + maxintensityproj(currStacks{kk},3);
                viewSpots{kk}{2,ii} = viewSpots{kk}{2,ii} + maxintensityproj(currStacks{kk},2);
                viewSpots{kk}{3,ii} = viewSpots{kk}{3,ii} + maxintensityproj(currStacks{kk},1)';
            end
        end
    end
end

outputViews = cell(numel(listOfFiles{1}),1);
timepoints = cell(3,1);
[outputViews{:}] = deal(timepoints);
for ii = 1:numel(viewSpots)
   outputViews{ii}{1} = [viewSpots{ii}{1,:}]; 
   outputViews{ii}{2} = [viewSpots{ii}{2,:}]; 
   outputViews{ii}{3} = [viewSpots{ii}{3,:}]; 
end
outputViews = ncellfun(@norm2UINT255,viewSpots);
end