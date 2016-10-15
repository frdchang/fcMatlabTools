%% processing data
phaseRegexp     = 'BrightFieldTTL';
spotRegexp      = {'FITC\(WhiteTTL\)'};
expFolder       = '/Users/fchang/Dropbox/Public/smalldataset/fcDataStorage/201601-test-adf';
%expFolder      = '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160915-mitosis-BWY804_4-4/doTimeLapse_1';
phaseFiles      = getAllFiles(expFolder,phaseRegexp);
spotFiles       = getAllFiles(expFolder,spotRegexp);

processQPM      = applyFuncTo_ListOfFiles(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{},@saveToProcessed_images,{},'doParallel',true);
qpmImages       = grabFromListOfCells(processQPM.outputFiles,{'@(x) x{1}'});
qpmImages       = groupByTimeLapses(qpmImages);

spots           = applyFuncTo_ListOfFiles(spotFiles,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',1250},@saveToProcessed_fcSpotDetection,{},'doParallel',true);
spot_Thetas     = grabFromListOfCells(spots.outputFiles,{'@(x) x{1}'});
spot_A1s        = grabFromListOfCells(spots.outputFiles,{'@(x) x{2}'});
spot_LLRatios   = grabFromListOfCells(spots.outputFiles,{'@(x) x{3}'});
spot_A1s        = groupByTimeLapses(spot_A1s);
spot_LLRatios   = groupByTimeLapses(spot_LLRatios);
spot_Thetas     = groupByTimeLapses(spot_Thetas);

stageAlignments = applyFuncTo_ListOfFiles(qpmImages,@openData_passThru,{},@stageAlign,{},@saveToProcessed_stageAlign,{},'doParallel',false);
alignXYs        = sort_nat(stageAlignments.outputFiles);

% apply stage alignment to other channels
alignedQPM = applyFuncTo_ListOfFiles(glueCellArguments(qpmImages,alignXYs),@openData_passThru,{},@translateSeq,{},@ saveToProcessed_passThru,{},'doParallel',false);
% apply stage alignment to spots mle

save('~/Desktop/tempProcessing');