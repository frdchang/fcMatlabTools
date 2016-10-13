%% processing data
phaseRegexp = 'BrightFieldTTL';
spotRegexp = {'FITC\(WhiteTTL\)'};
expFolder = '/Users/fchang/Dropbox/Public/smalldataset/fcDataStorage/201601-test-adf';
%expFolder = '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160915-mitosis-BWY804_4-4/doTimeLapse_1';
phaseFiles = getAllFiles(expFolder,phaseRegexp);
spotFiles = getAllFiles(expFolder,spotRegexp);

processQPM = applyFuncTo_ListOfFiles(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{},@saveToProcessed_images,{},'doParallel',true);
qpmImages = cellfunNonUniformOutput(@(x) x{1},processQPM.outputFiles);
qpmImagesByStages = groupByRegexp(qpmImages,'_s[0-9]+');
qpmImagesByStagesOrdered = ncellfun(@orderListByTimePoints,qpmImagesByStages);

alignQpmImages = applyFuncTo_ListOfFiles(qpmImagesByStagesOrdered,@openData_passThru,{},@getXYstageAlignment,{},@saveToProcessed_getXYstageAlignment,{},'doParallel',false);

spots = applyFuncTo_ListOfFiles(spotFiles,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',1250},@saveToProcessed_fcSpotDetection,{},'doParallel',false);