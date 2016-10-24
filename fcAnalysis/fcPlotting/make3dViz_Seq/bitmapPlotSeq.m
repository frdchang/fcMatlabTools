function daBitmap = bitmapPlotSeq(cellOfSpotParams,myFunc,varargin)
%BITMAPPLOTSEQ given a cell list of spot params, it will plot the distances

%--parameters--------------------------------------------------------------
params.pixelLength     = [];
params.pixelHeight     = [];  % this is the units
params.recHeightPixels = 90;  % make it this tall
params.markerColor     = [1 1 1 1];
params.marker           = '*';
params.markerSize      = 1;
params.LineWidth       = 0;
params.heightBuffer    = 1.2;
params.units           = 1;
params.bkgndGrey       = 0.2;
params.axisColor       = 0.75;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numSeq = numel(cellOfSpotParams);

if isempty(params.pixelLength)
    bmpPlotLength = numSeq;
else
    bmpPlotLength = params.pixelLength;
end

if isempty(params.pixelHeight)
    % get maximum height from data
    maxDist = -inf;
    for ii = 1:numSeq
        currMaxDistances = max(myFunc(cellOfSpotParams{ii},params));
        maxDist = max(maxDist,currMaxDistances);
    end
    bmpPlotHeight = round(maxDist*params.heightBuffer);
else
    bmpPlotHeight = params.pixelHeight;
end
upRezHeight = params.recHeightPixels/bmpPlotHeight;
plotBkgnd = params.bkgndGrey*ones(bmpPlotHeight*upRezHeight ,bmpPlotLength);

% extract distances
seqIndex = [];
distances = [];
for ii = 1:numSeq
    currdistances = myFunc(cellOfSpotParams{ii},params);
    if ~isempty(currdistances)
    for jj = 1:numel(currdistances)
       seqIndex(end+1) = ii;
       distances(end+1) = currdistances(jj);
    end
    end
end

% add axis to bitmap
plotBkgnd(1,:) = params.axisColor;
plotBkgnd(:,1) = params.axisColor;

daBitmap = bitmapplot(distances*upRezHeight,seqIndex ,plotBkgnd,struct('Marker',params.marker,'MarkerColor',params.markerColor,'MarkerSize',params.markerSize,'LineWidth',params.LineWidth));
daBitmap = flipud(daBitmap);
