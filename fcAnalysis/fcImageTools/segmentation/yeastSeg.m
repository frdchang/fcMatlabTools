function yeastSegmented = yeastSeg(timeLapseFiles,L,varargin)
%YEASTSEG will segment timelapse of yeast given that the last timepoint is
%segmented
%--parameters--------------------------------------------------------------
params.saveToLocation = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

yeastSegmented = trackingYeast(timeLapseFiles,L,params);
% save segmented files
if ~isempty(params.saveToLocation)
    timeLapseSeg = yeastSegmented.all_obj.cells;
    for ii = 1:size(timeLapseSeg,3)
        exportStack(genSaveFile(params.saveToLocation,returnFileName(yeastSegmented.fileList{ii})),timeLapseSeg(:,:,ii));
    end
end
