%% redo spot detection 
tic;
processSpots    = applyFuncTo_listOfListOfArguments(spotFiles,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',300},@saveToProcessed_fcSpotDetection,{},'doParallel',false);
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

% apply stage alignment to other channels
processAlignedspot_A1s     = applyFuncTo_listOfListOfArguments(glueCellArguments(spot_A1s,alignXYs),@openData_passThru,{},@translateSeq,{},@ saveToProcessed_passThru,{},'doParallel',true);
processAlignedSpots_LLRatios = applyFuncTo_listOfListOfArguments(glueCellArguments(spot_LLRatios,alignXYs),@openData_passThru,{},@translateSeq,{},@saveToProcessed_passThru,{},'doParallel',true);
% apply stage alignment to spots mle
processAlignedSpots_Thetas = applyFuncTo_listOfListOfArguments(glueCellArguments(spot_Thetas,alignXYs),@openData_passThru,{},@translateSpots,{},@saveToProcessed_passThru,{},'doParallel',true);

alignedSpots_A1s        = convertListToListofArguments(processAlignedspot_A1s.outputFiles);
alignedSpots_Thetas     = convertListToListofArguments(processAlignedSpots_Thetas.outputFiles);
alignedSpots_LLRatios   = convertListToListofArguments(processAlignedSpots_LLRatios.outputFiles);

save([expFolder filesep 'processingState'],'-append');

extractedA1         = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_A1s,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',false);
extractedLLRatio    = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_LLRatios,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',false);
% extract Spots
extractedSpots      = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_Thetas,segmentedMatFiles),@openData_passThru,{},@extractSpots,{},@saveToProcessed_passThru,{},'doParallel',false);
save([expFolder filesep 'processingState'],'-append');

% make 3D visualization
process3DViz        = applyFuncTo_listOfListOfArguments(convert2CellBasedOrdering(extractedA1,extractedSpots,extractedQPM),@openData_passThru,{},@make3DViz_Seq,{},@saveToProcessed_passThru,{},'doParallel',true);

% make segmentation vis
segmentedViz        = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedQPM,segmentedIMGFiles),@openData_passThru,{},@makeSegViz_Seq,{},@saveToProcessed_passThru,{},'doParallel',false);
toc
save([expFolder filesep 'processingState'],'-append');
%% linux
expFolders = {  '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160823-mitosis-BWY764',...
                '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160823-mitosis-BWY805',...
                '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160830-mitosis-BWY821',...
                '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160830-mitosis-BWY827',...
                '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160915-mitosis-BWY819-14'};

%% processing multiple experiments
expFolders = {  '/Volumes/robin/fcDataStorage/20160201-test-adf',...
                '/Volumes/robin/fcDataStorage/20160201-test-adfasdf',...
                '/Volumes/robin/fcDataStorage/20160202-test-adfahgaga'};
            
for ii=1:numel(expFolders)
    part1(expFolders{ii});
end

% segment last time points
for ii=1:numel(expFolders)
    part2(expFolders{ii});
end
%% processing data
phaseRegexp     = 'FITC\(BrightFieldTTL\)';
spotRegexp      = {'FITC\(WhiteTTL\)','cy5\(WhiteTTL\)'};
expFolder       = '/mnt/btrfs/fcDataStorage/fcCheckout/andrian/20151023/cyano';
%expFolder      = '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160915-mitosis-BWY804_4-4/doTimeLapse_1';
phaseFiles      = getAllFiles(expFolder,phaseRegexp);
spotFiles       = getAllFiles(expFolder,spotRegexp);
myLLRatio       = 800;%300;
calibrationFileList = {'~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat',...
                       '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat',...
                       '~/Dropbox/code/Matlab/fcBinaries/origCameraCal20160410.mat'};
calibrationFile = calibrationFileList{3};

% convert list of files to listOfListOfArguments
phaseFiles      = convertListToListofArguments(phaseFiles);
spotFiles       = convertListToListofArguments(spotFiles);

processQPM      = applyFuncTo_listOfListOfArguments(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{},@saveToProcessed_images,{},'doParallel',true);
qpmImages       = groupByTimeLapses(processQPM.outputFiles);
qpmImages       = convertListToListofArguments(qpmImages);
save([expFolder filesep 'processingState']);

processSpots    = applyFuncTo_listOfListOfArguments(spotFiles,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',myLLRatio,'pathToCalibration',calibrationFile},@saveToProcessed_fcSpotDetection,{},'doParallel',false);
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
alignedSpots_A1s        = convertListToListofArguments(processAlignedspot_A1s.outputFiles);
alignedSpots_Thetas     = convertListToListofArguments(processAlignedSpots_Thetas.outputFiles);
alignedSpots_LLRatios   = convertListToListofArguments(processAlignedSpots_LLRatios.outputFiles);

save([expFolder filesep 'processingState'],'-append');


%% grab the rois
roiZips       = grabFromListOfCells(processAlignedQPM.outputFiles,{'@(x) x{1}'});
roiZips       = returnFilePath(roiZips);
roiZips       = cellfunNonUniformOutput(@(x) removeDoubleFileSep([x filesep 'RoiSet.zip']),roiZips);
roiZips       = convertListToListofArguments(roiZips);
tic;
segmented = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedQPM,roiZips),@openData_passThru,{},@yeastSeg,{},@saveToProcessed_yeastSeg,{},'doParellel',false);

% extract cells
segmentedMatFiles   = cellfunNonUniformOutput(@(x) x.segMatFile,segmented.outputFiles);
segmentedIMGFiles   = cellfunNonUniformOutput(@(x) x.segSequenceFiles,segmented.outputFiles);
segmentedIMGFiles   = convertListToListofArguments(segmentedIMGFiles);
segmentedMatFiles   = convertListToListofArguments(segmentedMatFiles);
extractedQPM        = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedQPM,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',false);
extractedA1         = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_A1s,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',false);
extractedLLRatio    = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_LLRatios,segmentedMatFiles),@openData_passThru,{},@extractCells,{},@saveToProcessed_passThru,{},'doParallel',false);
% extract Spots
extractedSpots      = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedSpots_Thetas,segmentedMatFiles),@openData_passThru,{},@extractSpots,{},@saveToProcessed_passThru,{},'doParallel',false);
save([expFolder filesep 'processingState'],'-append');

% make 3D visualization
process3DViz        = applyFuncTo_listOfListOfArguments(convert2CellBasedOrdering(extractedA1,extractedSpots,extractedQPM,extractedLLRatio),@openData_passThru,{},@make3DViz_Seq,{},@saveToProcessed_passThru,{},'doParallel',true);

% make segmentation vis
segmentedViz        = applyFuncTo_listOfListOfArguments(glueCellArguments(alignedQPM,segmentedIMGFiles),@openData_passThru,{},@makeSegViz_Seq,{},@saveToProcessed_passThru,{},'doParallel',false);
toc
save([expFolder filesep 'processingState'],'-append');