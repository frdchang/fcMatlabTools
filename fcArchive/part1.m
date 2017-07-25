function [] = part1(expFolder)
%PART1 Summary of this function goes here
%   Detailed explanation goes here

%% processing data
phaseRegexp     = 'BrightFieldTTL';
spotRegexp      = {'FITC\(WhiteTTL\)'};

phaseFiles      = getAllFiles(expFolder,phaseRegexp);
spotFiles       = getAllFiles(expFolder,spotRegexp);

% convert list of files to listOfListOfArguments
phaseFiles      = convertListToListofArguments(phaseFiles);
spotFiles       = convertListToListofArguments(spotFiles);

processQPM      = applyFuncTo_listOfListOfArguments(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{},@saveToProcessed_images,{},'doParallel',true);
qpmImages       = groupByTimeLapses(processQPM.outputFiles);
qpmImages       = convertListToListofArguments(qpmImages);
save([expFolder filesep 'processingState'],'-append');

processSpots    = applyFuncTo_listOfListOfArguments(spotFiles,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',700},@saveToProcessed_fcSpotDetection,{},'doParallel',false);
spot_Thetas     = grabFromListOfCells(processSpots.outputFiles,{'@(x) x{1}'});
spot_A1s        = grabFromListOfCells(processSpots.outputFiles,{'@(x) x{2}'});
spot_LLRatios   = grabFromListOfCells(processSpots.outputFiles,{'@(x) x{3}'});
spot_A1s        = groupByTimeLapses(spot_A1s);
spot_LLRatios   = groupByTimeLapses(spot_LLRatios);
spot_Thetas     = groupByTimeLapses(spot_Thetas);
spot_A1s        = convertListToListofArguments(spot_A1s);
spot_LLRatios   = convertListToListofArguments(spot_LLRatios);
spot_Thetas     = convertListToListofArguments(spot_Thetas);
save([expFolder filesep 'processingState'],'-append');

processAlignments   = applyFuncTo_listOfListOfArguments(qpmImages,@openData_passThru,{},@stageAlign,{},@saveToProcessed_stageAlign,{},'doParallel',false);
alignXYs            = sort_nat(processAlignments.outputFiles);
alignXYs            = convertListToListofArguments(alignXYs);
save([expFolder filesep 'processingState'],'-append');

% apply stage alignment to other channels
processAlignedQPM          = applyFuncTo_listOfListOfArguments(glueCellArguments(qpmImages,alignXYs),@openData_passThru,{},@translateSeq,{},@ saveToProcessed_passThru,{},'doParallel',true);
% apply stage alignment to other channels
processAlignedspot_A1s     = applyFuncTo_listOfListOfArguments(glueCellArguments(spot_A1s,alignXYs),@openData_passThru,{},@translateSeq,{},@ saveToProcessed_passThru,{},'doParallel',true);
processAlignedSpots_LLRatios = applyFuncTo_listOfListOfArguments(glueCellArguments(spot_LLRatios,alignXYs),@openData_passThru,{},@translateSeq,{},@saveToProcessed_passThru,{},'doParallel',true);
% apply stage alignment to spots mle
processAlignedSpots_Thetas = applyFuncTo_listOfListOfArguments(glueCellArguments(spot_Thetas,alignXYs),@openData_passThru,{},@translateSpots,{},@saveToProcessed_passThru,{},'doParallel',true);

alignedQPM              = convertListToListofArguments(processAlignedQPM.outputFiles);
alignedSpots_A1s         = convertListToListofArguments(processAlignedspot_A1s.outputFiles);
alignedSpots_Thetas     = convertListToListofArguments(processAlignedSpots_Thetas.outputFiles);
alignedSpots_LLRatios   = convertListToListofArguments(processAlignedSpots_LLRatios.outputFiles);

save([expFolder filesep 'processingState'],'-append');
