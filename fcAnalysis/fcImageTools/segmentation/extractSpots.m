function spotInACell  = extractSpots(listOfSpotMLEs,segMatFile,varargin)
%EXTRACTSPOTS will extract spots for each cell given a matfile
%--parameters--------------------------------------------------------------
params.LLRatioThreshold     = 0;
params.borderVector         = [20 20];  % make sure this matches extractCELL!!
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

segmentation = load(segMatFile);
segmentation = segmentation.segOutput;

numCells = max(segmentation.all_obj.cells(:));
numTimePoints = size(segmentation.all_obj.cells,3);

%% find the largest bounding box that enapsulates the cell over the timelapse
maxBBoxForEachCell = findMaxBBoxForSeq(segmentation.all_obj.cells,segmentation.all_obj.cell_area);
%% extract spots using that bounding box found above and save
spotInACell = cell(numTimePoints,numCells);

for ii = 1:numTimePoints
    display(['extractSpots(): ' num2str(ii) ' of ' num2str(numTimePoints) ' timepoints']);
    currSpotMLEs = listOfSpotMLEs{ii};
    currSeg   = segmentation.all_obj.cells(:,:,ii);
    spotParamsInL = returnSpotParamsInL(currSpotMLEs,currSeg);
    
    [~,allTheBBox] = extractCellForATimePoint(currSeg,currSeg,maxBBoxForEachCell,params.borderVector,0);
    
    if numel(spotParamsInL) < numCells
        spotParamsInL{numCells} = [];
    end
    
    for jj = 1:numCells
        spotInACell{ii,jj} = BBoxCorrectSpotParams(spotParamsInL{jj},allTheBBox{jj});
    end
end