function [allTheCells,allTheBBox] = extractCellForATimePoint(currStack,currSeg,maxBBoxForEachCell,borders,howToMask)
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
allTheBBox = cell(numCells,1);

maxBBoxSize =  max(cat(1,maxBBoxForEachCell{:}));
% setup cache
maxBBox = zeros(1,numel(maxBBoxSize)*2);
maxBBox(numel(maxBBox)/2+1:end) = maxBBoxSize;
getSubsetwBBoxNDcache1(currStack,maxBBox,'borderVector',borders,'skipCacheCheck',false);
for ii = 1:numCells
    currCellinL = (currSeg == ii);
    if any(currCellinL(:))
        % there is that ii cell
%         currStats           = regionprops(bwconvhull(currCellinL),'Centroid','BoundingBox');
        currCentroid                = calcCentroidofBW(currCellinL); % this is faster
        currBBox                    = centroidWSize2BBox(currCentroid,maxBBoxForEachCell{ii});
              
        [currCell,allTheBBox{ii}]   = getSubsetwBBoxNDcache1(currStack,currBBox,'borderVector',borders,'skipCacheCheck',true);
        switch howToMask
            case 0
                maskedCell = currCell;
            case 1
                currL               = getSubsetwBBoxNDcache2(currCellinL,currBBox,'borderVector',borders,'skipCacheCheck',false);
                maskedCell          = maskDataND(currCell,currL);
            case 2
                currL               = getSubsetwBBoxNDcache2(currCellinL,currBBox,'borderVector',borders,'skipCacheCheck',false);
                outline = bwperim(currL);
                maskedCell = currCell;
                maskedCell(outline) = inf;
            otherwise
                
        end
        allTheCells{ii}     = maskedCell;
    else
        % there is no ii cell
        allTheCells{ii} = {};
    end
end


end

