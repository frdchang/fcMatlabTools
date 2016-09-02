function candidates = findSpotsStage2(detected,spotData,varargin)
%FINDSPOTSSTAGE2 find candidate regions among the processed output of the
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
params.strategy          = 'threshold';         % {'hdome','threshold','autoSpotFindingThreshold'}
%==universal parameters====================================================
params.smoothingKernel   = [0.9,0.9,0.9];   % smooths LLRatio
params.smoothingSize     = [7 7 7];
% params.minVol            = 3;             % make sure candidate is > minVol
params.Athreshold        = 0;               % select regions where A > Athreshold
params.clearBorder       = true;            % clear border on xy perimeter
%==hdome specific parameters===============================================
params.hdomeH            = 1e5;
params.thresholdHDome    = 'otsu';  %{'otsu',thresholdValue}
%==threshold specific parameters===========================================
params.LLRatioThresh     = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%% universal computation
[~,sepKernel] = ndGauss(params.smoothingKernel,params.smoothingSize);
smoothLLRatio = convSeparableND(detected.LLRatio,sepKernel);
smoothLLRatio = unpadarray(smoothLLRatio,size(detected.LLRatio));
Athresholded = detected.A1 > params.Athreshold;


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
    case 'autoSpotFindingThreshold'
        
    otherwise
        error('unrecognized strategy');
end

%% universal computation
BWmask = Athresholded.*selectedRegions;

if params.clearBorder
    BWmask = clearXYBorder(BWmask);
end



% segment spots
stats = regionprops(BWmask>0,'PixelIdxList','PixelList','Centroid');
% newStats = defineBBBoxOnCentroids(stats,BBox);

candidates.BWmask   = BWmask;
candidates.stats    = stats;
