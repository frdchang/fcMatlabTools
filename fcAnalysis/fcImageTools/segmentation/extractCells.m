function saveCellFilePaths = extractCells(listOfFiles,segMatFile,varargin)
%EXTRACTCELLS will extract the cells according to segmentation file
%segMatFile, assume it is 2D.

%--parameters--------------------------------------------------------------
params.borderVector    = [20 20];  % make sure this matches extractSpots!!!!
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

segmentation = load(segMatFile);
segmentation = segmentation.segOutput;

numCells = max(segmentation.all_obj.cells(:));
numTimePoints = size(segmentation.all_obj.cells,3);

%% find the largest bounding box that enapsulates the cell over the timelapse
maxBBoxForEachCell = findMaxBBoxForSeq(segmentation.all_obj.cells,segmentation.all_obj.cell_area);

%% extract cells using that bounding box found above and save
saveCellFilePaths = cell(numTimePoints,numCells);

for ii = 1:numTimePoints
    display(['extractCells(): ' num2str(ii) ' of ' num2str(numTimePoints) '  ' listOfFiles{ii}]);
    currStack = importStack(listOfFiles{ii});
    currSeg   = segmentation.all_obj.cells(:,:,ii);
    % if it is a qpm file extract cell using qpm highlighting
    if ~isempty(strfind(returnFileName(listOfFiles{ii}),'genQPM')) || ~isempty(strfind(returnFileName(listOfFiles{ii}),'gnQPM'))
        allTheCells = extractCellForATimePoint(currStack,currSeg,maxBBoxForEachCell,params.borderVector,2);
    else
        % otherwise mask data by -inf
        allTheCells = extractCellForATimePoint(currStack,currSeg,maxBBoxForEachCell,params.borderVector,1);
    end
    
    for jj = 1:numCells
        if ~isempty(allTheCells{jj})
            saveProcessedFileAt = genProcessedFileName(listOfFiles{ii},'extractCell');
            saveProcessedFileAtWithCellFolder = appendCellFolder(saveProcessedFileAt,jj);
            saveCellFilePaths{ii,jj} = exportStack(saveProcessedFileAtWithCellFolder,allTheCells{jj});
        else
            saveCellFilePaths{ii,jj} = {};
        end
    end
end

