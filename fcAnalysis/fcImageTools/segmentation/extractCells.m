function saveCellFilePaths = extractCells(listOfFiles,segMatFile,varargin)
%EXTRACTCELLS will extract the cells according to segmentation file
%segMatFile, assume it is 2D.

%--parameters--------------------------------------------------------------
params.borderXY    = 5;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

segmentation = load(segMatFile);
segmentation = segmentation.segOutput;

numCells = max(segmentation.all_obj.cells(:));
numTimePoints = numel(listOfFiles);

%% find the largest bounding box that enapsulates the cell over the timelapse
maxBBoxForEachCell = findMaxBBoxForSeq(segmentation.all_obj.cells,segmentation.all_obj.cell_area);

%% extract cells using that bounding box found above and save
saveCellFilePaths = cell(numTimePoints,numCells);

for ii = 1:numTimePoints
    display(['extractCells(): ' num2str(ii) ' of ' num2str(numTimePoints) '  ' listOfFiles{ii}]);
    currStack = importStack(listOfFiles{ii});
    currSeg   = segmentation.all_obj.cells(:,:,ii);
    allTheCells = extractCellForATimePoint(currStack,currSeg,maxBBoxForEachCell,params.borderXY);
    for jj = 1:numCells
        if ~isempty(allTheCells{jj})
            saveProcessedFileAt = genProcessedFileName(listOfFiles{ii},'extractCell');
            saveProcessedFileAtWithCellFolder = appendCellFolder(saveProcessedFileAt,jj);
            exportStack(saveProcessedFileAtWithCellFolder,allTheCells{jj}); 
            saveCellFilePaths{ii,jj} = saveProcessedFileAtWithCellFolder;
        else
            saveCellFilePaths{ii,jj} = {};
        end
    end
end

