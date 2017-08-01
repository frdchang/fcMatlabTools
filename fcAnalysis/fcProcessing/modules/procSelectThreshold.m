function [thresholdSelected ] = procSelectThreshold(stageIOutputs,varargin )
%PROCSELECTTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here

 
%--parameters--------------------------------------------------------------
params.outputSelector     = 'LLRatio'; 
params.divisor            = 1;  % divide the image into this num
params.resizeToThis       = [600,1024];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% structs are stored at end
imageFiles = stageIOutputs.outputFiles.(params.outputSelector);
imageFiles = groupByTimeLapses(imageFiles);
projTimeLapseBasket = cell(numel(imageFiles),1);
% for each timelapse define threshold
for ii = 1:numel(imageFiles)
    currTimeLapse = imageFiles{ii};
    projTimeLapseImg = cell(1,numel(currTimeLapse));
    for jj = 1:numel(currTimeLapse)
        currImg = importStack(currTimeLapse{jj});
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
    projTimeLapseBasket{ii} = imresize(projTimeLapseImg,params.resizeToThis,'nearest');
end

thresholdSelected = cell(numel(imageFiles),1);
for ii = 1:numel(projTimeLapseBasket)
    [mythresh, ~, ~] = threshold(multithresh(projTimeLapseBasket{ii}(:)), max(projTimeLapseBasket{ii}(:)), projTimeLapseBasket{ii});
    thresholdSelected{ii} = mythresh; 
end


