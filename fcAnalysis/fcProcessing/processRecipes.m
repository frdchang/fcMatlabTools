%% processing data
phaseRegexp = 'BrightFieldTTL';
spotRegexp = {'FITC\(WhiteTTL\)'};
 expFolder = '/Users/fchang/Dropbox/Public/smalldataset/fcDataStorage/201601-test-adf';
%expFolder = '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20160915-mitosis-BWY804_4-4/doTimeLapse_1';
phaseFiles = getAllFiles(expFolder,phaseRegexp);
spotFiles = getAllFiles(expFolder,spotRegexp);

test = applyFuncTo_ListOfFiles(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{},@saveToProcessed_images,{},'doParallel',true);



%% 

spots = applyFuncTo_ListOfFiles(spotFiles,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',1250},@saveToProcessed_fcSpotDetection,{},'doParallel',false);