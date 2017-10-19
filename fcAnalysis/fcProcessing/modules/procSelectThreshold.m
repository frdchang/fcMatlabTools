function [thresholdOutputs] = procSelectThreshold(stageIOutputs,varargin )
%PROCSELECTTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here

 
%--parameters--------------------------------------------------------------
params.selectField     = 'LLRatio'; 
params.divisor            = 1;  % divide the image into this num
params.resizeToThis       = [600,1024];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% structs are stored at end
imageFiles = stageIOutputs.outputFiles.(params.selectField);
[imageFiles,idxs] = groupByTimeLapses(imageFiles);
projTimeLapseBasket = cell(numel(imageFiles),1);
% for each timelapse define threshold
for ii = 1:numel(imageFiles)
    currTimeLapse = imageFiles{ii};
    projTimeLapseImg = cell(1,numel(currTimeLapse));
    for jj = 1:numel(currTimeLapse)
        currImg = importStack(currTimeLapse{jj});
        saveCurrImg = xyMaxProjND(currImg);
        currImg = maxintensityproj(currImg,3);
        % calcualte how to divide the image
        imgSize = size(currImg);
        increment = floor(imgSize(2)/params.divisor);
        leftOver  = imgSize(2) - increment*params.divisor;
        dividerVals = zeros(params.divisor,1);
        [dividerVals(:)] = increment;
        dividerVals(end) = dividerVals(end)+leftOver;
        currImg = mat2cell(currImg,dividerVals);
        currImg = cellfunNonUniformOutput(@(x) max(x,[],1)',currImg);
        projTimeLapseImg{jj} = cell2mat(currImg);
    end
    projTimeLapseImg = cell2mat(projTimeLapseImg)';
    projTimeLapseBasket{ii} = cat(2,saveCurrImg,imresize(projTimeLapseImg,size(saveCurrImg),'nearest'));
end

thresholdSelected = cell(numel(imageFiles),1);
for ii = 1:numel(projTimeLapseBasket)
    [mythresh, ~, ~] = threshold(multithresh(projTimeLapseBasket{ii}(:)), max(projTimeLapseBasket{ii}(:)), projTimeLapseBasket{ii});
    thresholdSelected{ii} = mythresh; 
end
outputFilesFlattened = zeros(numel(stageIOutputs.outputFiles.(params.selectField)),1);
cellfun(@helper,idxs,thresholdSelected);
thresholdOutputs.inputFiles  = imageFiles;
thresholdOutputs.outputFiles = table(thresholdSelected,'VariableNames',{'thresholds'});
thresholdOutputs.outputFilesFlattened = outputFilesFlattened;
thresholdOutputs = procSaver(stageIOutputs,thresholdOutputs);

function [] = helper(idxs,thresholdSelected)
outputFilesFlattened(idxs) = thresholdSelected;
end

end


