%% processing data
phaseRegexp = 'BrightFieldTTL';
spotRegexp = {'FITC\(WhiteTTL\)'};
expFolder = '/Users/fchang/Dropbox/Public/smalldataset/fcData/201601-test-adf';

phaseFiles = getAllFiles(expFolder,phaseRegexp);
spotFiles = getAllFiles(expFolder,spotRegexp);

test = applyFuncTo_ListOfFiles(phaseFiles,@openImage_applyFuncTo,{},@genQPM,{},@saveToProcessed_images,{});


