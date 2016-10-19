function allTheCells = extractCellForATimePoint(currStack,currSeg,maxBBoxForEachCell,borders)
%EXTRACTCELLFORATIMEPOINT will extract each cell and output them as a cell
% array 
%
% currStack:            a given dataset nd
% currSeg:              an indexed segmentation, like L
% maxBBoxForEachCell:   a cell list of the max size each bounding box
%                       should be for each cell
% borders:              array that specifies border size in each dimension
%
% note that -inf is padded when the BBox goes outside of the currStack size

numCells = numel(maxBBoxForEachCell);
allTheCells = cell(numCells,1);

for ii = 1:numCells
    currCellinL = (currSeg == ii);
    if any(currCellinL(:))
        % there is that ii cell
        currStats           = regionprops(currCellinL,'Centroid','BoundingBox');
        currBBox            = centroidWSize2BBox(currStats.Centroid,maxBBoxForEachCell{ii});
        allTheCells{ii}     = getSubsetwBBoxND(currStack,currBBox,'borderVector',borders);
    else
        % there is no ii cell
        allTheCells{ii} = {};
    end
end


end

