function allTheCells = extractCellForATimePoint(currStack,currSeg,maxBBoxForEachCell,borders,howToMask)
%EXTRACTCELLFORATIMEPOINT will extract each cell and output them as a cell
% array.  will mask out non segmented portion as -inf.
%
% currStack:            a given dataset nd
% currSeg:              an indexed segmentation, like L
% maxBBoxForEachCell:   a cell list of the max size each bounding box
%                       should be for each cell
% borders:              array that specifies border size in each dimension
% howToMask:            1 -> will mask by setting outside values to -inf
%                       2 -> will outline segmentation with colored line
%                       0 -> just naked cell
%
% note that -inf is padded when the BBox goes outside of the currStack size

colorPerimeter = [1 1 1];

numCells = numel(maxBBoxForEachCell);
allTheCells = cell(numCells,1);
fprintf([repmat('.',1,numCells) '\n\n']);
for ii = 1:numCells
    fprintf('\b|\n');
    currCellinL = (currSeg == ii);
    if any(currCellinL(:))
        % there is that ii cell
        currStats           = regionprops(currCellinL,'Centroid','BoundingBox');
        currBBox            = centroidWSize2BBox(currStats.Centroid,maxBBoxForEachCell{ii});
        currCell            = getSubsetwBBoxND(currStack,currBBox,'borderVector',borders);
        switch howToMask
            case 0
                maskedCell = currCell;
            case 1
                currL               = getSubsetwBBoxND(currCellinL,currBBox,'borderVector',borders);
                maskedCell          = maskDataND(currCell,currL);
            case 2
                currL               = getSubsetwBBoxND(currCellinL,currBBox,'borderVector',borders);
                maskedCell          = imoverlay(uint8(currCell),bwperim(currL),colorPerimeter);
            otherwise
                
        end
        allTheCells{ii}     = maskedCell;
    else
        % there is no ii cell
        allTheCells{ii} = {};
    end
end


end
