function [ output ] = manualSeg(timeLapseFiles,varargin)
%MANUALSEG will segment by manual selection
%--parameters--------------------------------------------------------------
params.saveToLocation = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

myMax = -inf;
for ii = 1:numel(timeLapseFiles)
    currStack = importStack(timeLapseFiles{ii});
    currStack = xyMaxProjND(currStack);
    
    myMax = max(myMax,currStack);
end

% get segmentation
roiwindow = CROIEditor(norm0to1(log(myMax)));

waitfor(roiwindow,'roi');
if ~isvalid(roiwindow)
    error('you closed the window without applying a ROI, exiting...');
    return
end

% get ROI information, like binary mask, labelled ROI, and number of
% ROIs defined
[mask, labels, n] = roiwindow.getROIData;
delete(roiwindow);

segmented = repmat(labels,1,1,numel(timeLapseFiles));
if n < 255
 segmented = uint8(segmented);
end
cell_area_basket = zeros(n,numel(timeLapseFiles));
for ii = 1:n
   currCell = labels == ii;
   currArea = sum(currCell(:));
   cell_area_basket(ii,:) = currArea;
end

output.all_obj.cells        = segmented;
output.all_obj.cell_area    = cell_area_basket;
output.params               = [];
output.LcellsO              = mask;
output.fileList             = timeLapseFiles;
output.numbM                = numel(timeLapseFiles);


end

