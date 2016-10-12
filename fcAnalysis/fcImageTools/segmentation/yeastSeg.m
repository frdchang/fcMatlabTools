function segmentedFiles = yeastSeg(timeLapseFiles,filePathToROIzip,varargin)
%YEASTSEG will segment timelapse of yeast given that the last timepoint is
%segmented
%--parameters--------------------------------------------------------------
params.saveToLocation = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

L = genLfromROIzip(filePathToROIzip,sizeOfData);
yeastSegmented = trackingYeast(timeLapseFiles,L,varargin);
% save segmented files
if ~isempty(params.saveToLocation)
    timeLapseSeg = yeastSegmented.all_obj.cells;
    for ii = 1:size(timeLapseSeg,3)
        exportStack(genSaveFile(params.saveToLocation,returnFileName(yeastSegmented.fileList{ii})),timeLapseSeg(:,:,ii));
    end
end
