function [ output_args ] = setupYeastCellTracking(input_args)
%SETUPCELLTRACKING Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
p.addRequired('orderedFileList',@(x) true);
p.addParamValue('lastFrameSegmented',[],@(x) true);
p.addParamValue('max_size_vs_largest_cell',1.33,@(x) true);
p.addParamValue('max_area_increase_per_tp',0.075,@(x) true);
p.addParamValue('higher_threshold',0.4,@(x) true);
p.addParamValue('lower_threshold',0.2,@(x) true);
p.addParamValue('threshold_increase_factor',0.2,@(x) true);
p.addParamValue('phase_subtraction_factor',1.2,@(x) true);
p.addParamValue('min_cell_size',10,@(x) true);
p.addParamValue('cell_margin',12,@(x) true);
p.addParamValue('doParallel',true,@(x) true);


p.parse(varargin{:});
input = p.Results;
orderedFileList                 = input.orderedFileList;
lastFrameSegmented              = input.lastFrameSegmented;
max_size_vs_largest_cell        = input.max_size_vs_largest_cell;
max_area_increase_per_tp        = input.max_area_increase_per_tp;
higher_threshold                = input.higher_threshold;
lower_threshold                 = input.lower_threshold;
threshold_increase_factor       = input.threshold_increase_factor;
phase_subtraction_factor        = input.phase_subtraction_factor;
min_cell_size                   = input.min_cell_size;
cell_margin                     = input.cell_margin;
doParallel                      = input.doParallel;

params.max_size_vs_largest_cell = max_size_vs_largest_cell;
params.max_area_increase_per_tp = max_area_increase_per_tp;
params.higher_threshold         = higher_threshold;
params.lower_threshold          = lower_threshold;
params.threshold_increase_factor=threshold_increase_factor;
params.phase_subtraction_factor = phase_subtraction_factor;
params.min_cell_size            = min_cell_size;
params.cell_margin              = cell_margin;

trackingSeedData.L = lastFrameSegmented;
trackingSeedData.orderedFileList = orderedFileList;
output = CT_track_modByFred(params,trackingSeedData,doParallel);
end




