function yeastSegmented = trackingYeast(timeLapseFiles,lastTimePointSegmented,varargin)
%SETUPCELLTRACKING applies skotheim's yeast segmentation.
%
% timeLapseFiles:   a cell list of the time lapse files in order
% lastTimePointSegmented: last timepoint should be segmented "L"

%--parameters--------------------------------------------------------------
params.max_size_vs_largest_cell     = 1.33;
params.max_area_increase_per_tp     = 0.075;
params.higher_threshold             = 0.4;
params.lower_threshold              = 0.2;
params.threshold_increase_factor    = 0.2;
params.phase_subtraction_factor     = 1.2;
params.min_cell_size                = 10;
params.cell_margin                  = 12;
params.doParallel                   = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

segparams.max_size_vs_largest_cell     = params.max_size_vs_largest_cell;
segparams.max_area_increase_per_tp     = params.max_area_increase_per_tp;
segparams.higher_threshold             = params.higher_threshold;
segparams.lower_threshold              = params.lower_threshold;
segparams.threshold_increase_factor    = params.threshold_increase_factor;
segparams.phase_subtraction_factor     = params.phase_subtraction_factor;
segparams.min_cell_size                = params.min_cell_size;
segparams.cell_margin                  = params.cell_margin;

trackingSeedData.L = lastTimePointSegmented;
trackingSeedData.orderedFileList = timeLapseFiles;

yeastSegmented = CT_track_modByFred(segparams,trackingSeedData,params.doParallel);





