function [] = part2(expFolder)
%PART2 Summary of this function goes here
%   Detailed explanation goes here
load([expFolder filesep 'processingState']);
%% grab the rois
roiZips       = grabFromListOfCells(processAlignedQPM.outputFiles,{'@(x) x{1}'});
roiZips       = returnFilePath(roiZips);
roiZips       = cellfunNonUniformOutput(@(x) removeDoubleFileSep([x filesep 'RoiSet.zip']),roiZips);
roiZips       = convertListToListofArguments(roiZips);

segmented = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedQPM,roiZips),@openData_passThru,{},@yeastSeg,{},@saveToProcessed_yeastSeg,{},'doParellel',false);

% extract cells
segmentedMatFiles   = cellfunNonUniformOutput(@(x) x.segMatFile,segmented.outputFiles);
segmentedMatFiles   = convertListToListofArguments(segmentedMatFiles);
extractedQPM        = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedQPM,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',true);
extractedA1         = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_A1s,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',true);
extractedLLRatio    = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_LLRatios,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',true);
% extract Spots
extractedSpots      = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_Thetas,segmentedMatFiles),@openData_passThru,{},@extractSpots,{},@saveToProcessed_passThru,{},'doParallel',true);

save([expFolder filesep 'processingState'],'-append');
