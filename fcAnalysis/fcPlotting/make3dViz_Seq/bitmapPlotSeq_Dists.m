function daBitmap = bitmapPlotSeq_Dists(cellOfSpotParams,varargin)
%BITMAPPLOTSEQ given a cell list of spot params, it will plot the distances

%--parameters--------------------------------------------------------------
params.pixelLength     = [];
params.pixelHeight     = [];
params.bkgndColor      = [0.2,0.2,0.2];
params.markerColor     = [1 1 1];
params.heightBuffer    = 1.2;
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
        currMaxDistances = max(returnPairWiseDistsOfSpotParam(cellOfSpotParams{ii}));
        maxDist = max(maxDist,currMaxDistances);
    end
    bmpPlotHeight = round(maxDist*params.heightBuffer);
else
    bmpPlotHeight = params.pixelHeight;
end

plotBkgnd = ones(bmpPlotHeight,bmpPlotLength);

end

