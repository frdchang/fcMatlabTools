function [ outputViews ] = buildViewSpots(listOfFiles,spotParamsPaths,upRezFactor,varargin)
%BUILDVIEWSPOTS Summary of this function goes here
%   Detailed explanation goes here
 
%--parameters--------------------------------------------------------------
params.markerRadius     = 1;
params.doAllTimePoints    = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

SE = strel('sphere',params.markerRadius);

if isempty(listOfFiles)
    viewSpots = [];
    return;
end
numSeq = numel(listOfFiles);

firstFile = getFirstNonEmptyCellContent(listOfFiles);
currFluor = importStack(firstFile);
sizeDatas  = getSize(currFluor);
upRezFactor = upRezFactor(1:numel(sizeDatas));

if ~params.doAllTimePoints
    numViews = ceil(numSeq/sizeDatas(2));
else
    numViews = numSeq;
end

viewSpots = cell(numel(listOfFiles{1}),1);
timepoints = cell(3,numViews);
temp = myIMResize(zeros(sizeDatas),upRezFactor.*sizeDatas,'nearest');
for ii = 1:numViews
    timepoints{1,ii} = maxintensityproj(temp,3);
    timepoints{2,ii} = maxintensityproj(temp,2);
    timepoints{3,ii} = maxintensityproj(temp,1)';
end

[viewSpots{:}] = deal(timepoints);
idx = round(linspace(1,numSeq,numViews));
for ii = 1:numel(idx)
    if ~isempty(spotParamsPaths{idx(ii)})
        % for each spot
        numSpots = 0;
        for jj = 1:numel(spotParamsPaths{idx(ii)})
            currSpot = spotParamsPaths{idx(ii)}{jj};
            selectedSpot = spotSelectorByThresh(currSpot,varargin{:});
            if isempty(selectedSpot)
               continue; 
            end
            selectedMLESingleSpot = selectedSpot.thetaMLEs;
            [~,singleSpotTheta,~] =  getSpotCoorsFromTheta(selectedMLESingleSpot);
            numSpots = numSpots + sum(~cellfun(@isempty,singleSpotTheta));
            currStacks   = cellfunNonUniformOutput(@(x) genSpotIMG(x,sizeDatas,upRezFactor),singleSpotTheta);
            currStacks   = cellfunNonUniformOutput(@(x) imdilate(x,SE),currStacks);
            for kk = 1:numel(currStacks)
                viewSpots{kk}{1,ii} = viewSpots{kk}{1,ii} + maxintensityproj(currStacks{kk},3);
                viewSpots{kk}{2,ii} = viewSpots{kk}{2,ii} + maxintensityproj(currStacks{kk},2);
                viewSpots{kk}{3,ii} = viewSpots{kk}{3,ii} + maxintensityproj(currStacks{kk},1)';
            end
        end
%         viewSpots{kk}{1,ii} = viewSpots{kk}{1,ii}*numSpots;
%         viewSpots{kk}{2,ii} = viewSpots{kk}{2,ii}*numSpots;
%         viewSpots{kk}{3,ii} = viewSpots{kk}{3,ii}*numSpots;
    end
end

outputViews = viewSpots;

% outputViews = cell(numel(listOfFiles{1}),1);
% timepoints = cell(3,1);
% [outputViews{:}] = deal(timepoints);
% for ii = 1:numel(viewSpots)
%     outputViews{ii}{1} = [viewSpots{ii}(1,:)];
%     outputViews{ii}{2} = [viewSpots{ii}(2,:)];
%     outputViews{ii}{3} = [viewSpots{ii}(3,:)];
% end
end