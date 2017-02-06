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
%==hdome specific parameters==========?=====================================
params.hdomeH            = 1e5;
params.thresholdHDome    = 'otsu';  %{'otsu',thresholdValue}
%==threshold specific parameters===========================================
params.LLRatioThresh     = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%% universal computation
sizeDataSet = size(estimated.LLRatio);
smoothLLRatio = convND(estimated.LLRatio,estimated.spotKern);
smoothLLRatio = unpadarray(smoothLLRatio,sizeDataSet);
Athresholded = estimated.A1 > params.Athreshold;


%% user specified computation
switch params.strategy
    case 'hdome'
        selectedRegions = hdome(smoothLLRatio,params.hdomeH);
        if strcmp(params.thresholdHDome,'otsu')
            params.thresholdHDome = multithresh(selectedRegions(:));
        end
        selectedRegions = selectedRegions > params.thresholdHDome;
    case 'threshold'
        if isempty(params.LLRatioThresh)
            [params.LLRatioThresh, ~, ~] = threshold(multithresh(detected.LLRatio(:)), max(detected.LLRatio(:)), maxintensityproj(detected.LLRatio,3));
        end
        selectedRegions = smoothLLRatio > params.LLRatioThresh;
    otherwise
        error('unrecognized strategy');
end

%% universal computations
BWmask = Athresholded.*selectedRegions;

if params.clearBorder
    BWmask = clearXYBorder(BWmask);
end

%% enforce minimal bounding box volumes
BWmask = BWmask > 0;
CC = bwconncomp(BWmask);
L = labelmatrix(CC);
stats = regionprops(L,'PixelIdxList','PixelList','Centroid','BoundingBox','Area');

% for those small volumes, give them minimum boundingBox
centroidMask = genSpotsFromCentroids(size(detected.A1),stats);
minBBoxMask = imdilate(centroidMask,strel(ones(params.minBBox)));
% combine the min mask with the current bwmask
BWmask = BWmask | minBBoxMask;
% split masks by meanshift
[L,~,~] = breakApartMasks(smoothLLRatio,BWmask);

% filter stats that have low volume
 L = bwareaopen(L,params.minVol);
 L = bwlabeln(L>0);
% need to have minimum volume 
candidates.L        = L;
% candidates.BWmask   = BWmask;
% candidates.stats    = stats;

