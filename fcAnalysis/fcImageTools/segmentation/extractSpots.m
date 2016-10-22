function saveSpotsFilePaths  = extractSpots(listOfSpotMLEs,segMatFile,varargin)
%EXTRACTSPOTS will extract spots for each cell given a matfile
%--parameters--------------------------------------------------------------
params.LLRatioThreshold     = 0;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

segmentation = load(segMatFile);
segmentation = segmentation.segOutput;

numCells = max(segmentation.all_obj.cells(:));
numTimePoints = numel(listOfSpotMLEs);


%% extract spots using that bounding box found above and save
saveSpotsFilePaths = cell(numTimePoints,numCells);

for ii = 1:numTimePoints
    display(['extractSpots(): ' num2str(ii) ' of ' num2str(numTimePoints) '  ' listOfSpotMLEs{ii}]);
    currSpotMLE = loadAndTakeFirstField(listOfSpotMLEs{ii});
    currSeg   = segmentation.all_obj.cells(:,:,ii);
    spotParamsInL = returnSpotParamsInL(currSpotMLE,currSeg);
    numSpotsInCurr = max(currSeg(:));
    if numel(spotParamsInL) < numCells
        spotParamsInL{numCells} = [];
    end
    
    for jj = 1:numCells
        if ~isempty(spotParamsInL{jj})
            saveProcessedFileAt = genProcessedFileName(listOfSpotMLEs{ii},'extractCell');
            saveProcessedFileAtWithCellFolder = appendCellFolder(saveProcessedFileAt,jj);
            saveSpotsFilePaths{ii,jj} = [saveProcessedFileAtWithCellFolder '.mat'];
            spotInCell = spotParamsInL{jj};
            makeDIRforFilename(saveProcessedFileAtWithCellFolder);
            save(saveProcessedFileAtWithCellFolder,'spotInCell');
        end
    end
end