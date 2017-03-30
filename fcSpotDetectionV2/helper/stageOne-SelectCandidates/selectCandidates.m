function candidates = selectCandidates(estimated,varargin)
%SELECTCANDIDATES find candidate regions among the processed output of the
% data from findSpotsStage1
%
% detected:     output struct from findSpotsStage1
% candidates:   output data structure organized as ...
%
% [notes] - this function output candidates as connected components that
%           does not have to be rectangular bounding boxes.  this
%           accomodates the fitting of spots to complex shapes.
%         - this function filters the LLRATIO > thresh and A parameter > 0,
%           then smooths it to do hdome local maxima search.
%         - then for those connected objects smaller than some value gives
%
%
% [param cascade] -> simpleThresholdDetection


%--parameters--------------------------------------------------------------
% you can just use simple 'threshold' or 'hdome'
params.strategy          = 'threshold';         % {'hdome','threshold'}
%==universal parameters====================================================
params.Athreshold        = 0;               % select regions where A > Athreshold
params.clearBorder       = true;            % clear border on xy perimeter
params.minVol            = 1;               % min volume of feature
%==hdome specific parameters==========?=====================================
params.hdomeH            = 1e3;
params.thresholdHDome    = 'otsu';  %{'otsu',thresholdValue}
%==threshold specific parameters===========================================
params.LLRatioThresh     = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%% universal computation
sizeDataSet = size(estimated.LLRatio);
if iscell(estimated.A1)
    smoothLLRatio = estimated.convFunc(estimated.LLRatio,estimated.spotKern{1});
     Athresholded = cellfunNonUniformOutput(@(x) x<params.Athreshold,estimated.A1);
     Athresholded = ~multiCellContents(Athresholded);
    
     if iscell(estimated.spotKern{1})
         error('did not calculate this part yuet');
     else
         sizeKern = size(estimated.spotKern{1});
     end
     
else
    smoothLLRatio = estimated.convFunc(estimated.LLRatio,estimated.spotKern);
    Athresholded = estimated.A1 > params.Athreshold;
    sizeKern = size(estimated.spotKern);
end



%% user specified computation
switch params.strategy
    case 'hdome'
        selectedRegions =  hdome(smoothLLRatio,params.hdomeH);
        if strcmp(params.thresholdHDome,'otsu')
            params.thresholdHDome = multithresh(selectedRegions(:));
        end
        selectedRegions = selectedRegions > params.thresholdHDome;
    case 'threshold'
        if isempty(params.LLRatioThresh)
            [params.LLRatioThresh, ~, ~] = threshold(multithresh(smoothLLRatio(:)), max(smoothLLRatio(:)), maxintensityproj(smoothLLRatio,3));
        end
        selectedRegions = smoothLLRatio > params.LLRatioThresh;
    otherwise
        error('unrecognized strategy');
end

%% universal computations
L = Athresholded.*selectedRegions;

if params.clearBorder
    L = clearXYBorder(L);
end

%% enforce minimal bounding box volumes
L = L > 0;
CC = bwconncomp(L);
L = labelmatrix(CC);
stats = regionprops(L,'PixelIdxList','PixelList','Centroid','BoundingBox','Area');

% for those small volumes, give them minimum boundingBox
centroidMask = genSpotsFromCentroids(size(estimated.LLRatio),stats);
minBBoxMask = imdilate(centroidMask,strel(ones(sizeKern)));
% combine the min mask with the current bwmask
L = L | minBBoxMask;
% % split masks by meanshift
[L,~,~] = breakApartMasks(smoothLLRatio,L);

% filter stats that have low volume
L = bwareaopen(L,params.minVol);
L = bwlabeln(L>0);
% need to have minimum volume
candidates.L        = L;
% candidates.BWmask   = BWmask;
% candidates.stats    = stats;

