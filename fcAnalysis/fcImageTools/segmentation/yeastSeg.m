function yeastSegmented = yeastSeg(timeLapseFiles,filePathToROIzip,varargin)
%YEASTSEG will segment timelapse of yeast given that the last timepoint is
%segmented
%--parameters--------------------------------------------------------------
params.saveToLocation = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% find size of file
sizeData = importStack(timeLapseFiles{1});
sizeOfData = size(sizeData);
if exist(filePathToROIzip) == 0
   error('you need to provide segmentation of last timepoint in a ROIzip'); 
end
L = genLfromROIzip(filePathToROIzip,sizeOfData);
yeastSegmented = trackingYeast(timeLapseFiles,L,params);
% save segmented files
if ~isempty(params.saveToLocation)
    timeLapseSeg = yeastSegmented.all_obj.cells;
    for ii = 1:size(timeLapseSeg,3)
        exportStack(genSaveFile(params.saveToLocation,returnFileName(yeastSegmented.fileList{ii})),timeLapseSeg(:,:,ii));
    end
end
