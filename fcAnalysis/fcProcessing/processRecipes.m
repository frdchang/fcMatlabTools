%% Fast 2 color case
expFolder  = '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180226-tdTomatoVsMcherry/20180226-tdTomatoVsMcherry-BWY777RG-timelapse/doTimeLapse_2/takeA3DStack';
camVarFile = '/home/fchang/Dropbox/code/Matlab/fcBinaries/calibration-ID300458-CoolerAIR-ROI512x512-SlowScan-sensorCorrectionON-20180227.mat';

psfObj1 = genGaussKernObj([0.9,0.9,0.9],[7 7 7]);
psfObj2 = genGaussKernObj([1,1,1],[7 7 7]);

specimenUnitsInMicrons = [0.1083,0.1083,0.389];  % axial scaling factor included

psfObjs = {psfObj1,psfObj2};
Kmatrix = [1 0.31; 0 1];
channels = {'redGr\(ChABTTL\)','redGr\(ChCTTL\)'};

phaseOutputs        = procGetImages(expFolder,'BrightFieldTTL','phaseOutputs',specimenUnitsInMicrons);
spotOutputs         = procGetImages(expFolder,channels,'spotOutputs',specimenUnitsInMicrons);

qpmOutputs          = procQPMs(phaseOutputs,'negateQPM',false,'doProcParallel',true);
xyAlignments        = procXYAlignments(qpmOutputs,'imgTableName','genQPM1','doProcParallel',false);

stageIOutputs       = procStageI(spotOutputs,psfObjs,'Kmatrix',Kmatrix,'stageIFunc',@findSpotsStage1V2,'camVarFile',camVarFile,'doProcParallel',true);
maxColoredProjs     = procProjectStageI(stageIOutputs,'projFunc',@maxColoredProj,'projFuncArg',{3});
xyMaxProjNDs        = procProjectStageI(stageIOutputs,'projFunc',@xyMaxProjND,'projFuncArg',{});

T_stageIOutputs     = procXYTranslate(xyAlignments,stageIOutputs,'doProcParallel',true);
T_maxColoredProjs   = procXYTranslate(xyAlignments,maxColoredProjs,'doProcParallel',true);
T_xyMaxProjNDs      = procXYTranslate(xyAlignments,xyMaxProjNDs,'doProcParallel',true);
T_qpmOutputs        = procXYTranslate(xyAlignments,qpmOutputs,'doProcParallel',true);
T_spotOutputs       = procXYTranslate(xyAlignments,spotOutputs,'doProcParallel',true);
T_phaseOutputs      = procXYTranslate(xyAlignments,phaseOutputs,'doProcParallel',true);

%-----USER-----------------------------------------------------------------
thresholdOutputs    = procSelectThreshold(stageIOutputs,'selectField','LLRatio');
T_edgeProfileZs     = procGetEdgeProfileZ(T_phaseOutputs,'end');
%--------------------------------------------------------------------------

cellMasks           = procThreshPhase(qpmOutputs,'thresholdFunc',@genMaskWOtsu,'phaseTableName','genQPM1','doProcParallel',true);
selectCands         = procSelectCandidates(stageIOutputs,thresholdOutputs,'cellMaskVariable','genMaskWOtsu1','cellMasks',cellMasks,'selectField','LLRatio','doProcParallel',true);
stageIIOutputs      = procStageII(stageIOutputs,selectCands,'doParallel',true);
T_stageIIOutputs    = procXYTranslateSpots(xyAlignments,stageIIOutputs);
T_yeastSegs         = procYeastSeg(T_phaseOutputs,T_qpmOutputs,T_edgeProfileZs,'doParallel',true,'doPlot',false);

eC_T_stageIOutputs  = procExtractCells(T_yeastSegs,T_stageIOutputs,'doParallel',true);
eC_T_qpmOutputs     = procExtractCells(T_yeastSegs,T_qpmOutputs,'doParallel',true);
eC_T_spotOutputs    = procExtractCells(T_yeastSegs,T_spotOutputs,'doParallel',true);

ec_T_stageIIOutputs = procExtractSpots(T_yeastSegs,T_stageIIOutputs);

%-----USER-----------------------------------------------------------------
spotThresholds      = procSpotThresholds(stageIIOutputs);
%--------------------------------------------------------------------------

trackedSpots        = procSpotTracking(ec_T_stageIIOutputs,'searchDist',20,'spotthresh',spotThresholds.thresholds);
ec_T_3Dviz          = proc3DViz(eC_T_spotOutputs,eC_T_stageIOutputs,ec_T_stageIIOutputs,eC_T_qpmOutputs,'spotthresh',spotThresholds.thresholds);
analyzedTracks      = procAnalyzeTracks(eC_T_spotOutputs,ec_T_3Dviz,trackedSpots);


%% process mreb
expFolder                = '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20170703-lowlabel-HaloSubtilius/doTimeLapse_6';
camVarFile               = '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';
Kmatrix                  = 1;
channels                 = {'mChry\(WhiteTTL\)'};
useFocalPlane            = 6;
specimenUnitsInMicrons   = [0.1083,0.1083,0.389];  % axial scaling factor included
psfObj1                  = genGaussKernObj([0.9,0.9,0.9],[7 7 7]);
psfObjs                  = {psfObj1};

phaseOutputs        = procGetImages(expFolder,'BrightFieldTTL','phaseOutputs',specimenUnitsInMicrons);
spotOutputs         = procGetImages(expFolder,channels,'spotOutputs',specimenUnitsInMicrons);

qpmOutputs          = procQPMs(phaseOutputs,'negateQPM',true,'doProcParallel',true,'ballSize',50,'nFocus',useFocalPlane);
xyAlignments        = procXYAlignments(qpmOutputs,'imgTableName','genQPM1','doProcParallel',false);

stageIOutputs       = procStageI(spotOutputs,psfObjs,'Kmatrix',Kmatrix,'stageIFunc',@findSpotsStage1V2cubed,'camVarFile',camVarFile,'doProcParallel',true);
maxColoredProjs     = procProjectStageI(stageIOutputs,'projFunc',@maxColoredProj,'projFuncArg',{3});
xyMaxProjNDs        = procProjectStageI(stageIOutputs,'projFunc',@xyMaxProjND,'projFuncArg',{});

T_stageIOutputs     = procXYTranslate(xyAlignments,stageIOutputs,'doProcParallel',true);
T_maxColoredProjs   = procXYTranslate(xyAlignments,maxColoredProjs,'doProcParallel',true);
T_xyMaxProjNDs      = procXYTranslate(xyAlignments,xyMaxProjNDs,'doProcParallel',true);
T_qpmOutputs        = procXYTranslate(xyAlignments,qpmOutputs,'doProcParallel',true);
T_spotOutputs       = procXYTranslate(xyAlignments,spotOutputs,'doProcParallel',true);
T_phaseOutputs      = procXYTranslate(xyAlignments,phaseOutputs,'doProcParallel',true);

%-----USER-----------------------------------------------------------------
thresholdOutputs    = procSelectThreshold(stageIOutputs,'selectField','LLRatio3');
T_edgeProfileZs     = procGetEdgeProfileZ(T_phaseOutputs,'end');
%--------------------------------------------------------------------------

cellMasks           = procThreshPhase(qpmOutputs,'thresholdFunc',@genMaskWOtsu,'phaseTableName','genQPM1','doProcParallel',true);
% selectCands         = procSelectCandidates(stageIOutputs,thresholdOutputs,'cellMaskVariable','genMaskWOtsu1','cellMasks',cellMasks,'selectField','LLRatio3','doProcParallel',true);
% use 5e8
selectCands         = procSelectCandidatesLinking(stageIOutputs,thresholdOutputs,'cellMaskVariable','genMaskWOtsu1','cellMasks',cellMasks,'selectField','LLRatio3','neighborTs',2,'doProcParallel',false,'doParallel',true);

%% changed
stageIIOutputs      = procStageII(stageIOutputs,selectCands,'doParallel',true,'newtonSteps',1,'hybridSteps',1,'gradSteps',200);
T_stageIIOutputs    = procXYTranslateSpots(xyAlignments,stageIIOutputs);

T_yeastSegs         = procManualSeg(T_xyMaxProjNDs);
% T_yeastSegs         = procYeastSeg(T_phaseOutputs,T_qpmOutputs,T_edgeProfileZs,'doParallel',true,'doPlot',false,'breakApart',false);

eC_T_stageIOutputs  = procExtractCells(T_yeastSegs,T_stageIOutputs,'doParallel',true);
eC_T_qpmOutputs     = procExtractCells(T_yeastSegs,T_qpmOutputs,'doParallel',true);
eC_T_spotOutputs    = procExtractCells(T_yeastSegs,T_spotOutputs,'doParallel',true);

ec_T_stageIIOutputs = procExtractSpots(T_yeastSegs,T_stageIIOutputs);

% spotthresholds 1 and 250
%-----USER-----------------------------------------------------------------
 spotThresholds      = procSpotThresholds(stageIIOutputs);
%--------------------------------------------------------------------------

% visualizeSpots      = procVizSpots(eC_T_stageIOutputs,ec_T_stageIIOutputs,'spotthresh',spotThresholds.thresholds);


trackedSpots        = procSpotTracking(ec_T_stageIIOutputs,'searchDist',2,'spotthresh',spotThresholds.thresholds);
ec_T_3Dviz          = proc3DViz(eC_T_spotOutputs,eC_T_stageIOutputs,ec_T_stageIIOutputs,eC_T_qpmOutputs,'spotthresh',spotThresholds.thresholds);
analyzedTracks      = procAnalyzeTracks(eC_T_spotOutputs,ec_T_3Dviz,trackedSpots);
gen3DTracks         = proc3DTracks(eC_T_qpmOutputs,eC_T_stageIOutputs,trackedSpots,'spotthresh',spotThresholds.thresholds);

%% test bulk modules on cluster
camVarFile = '/n/regal/kleckner_lab/fchang/fcDataStorage/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';
Kmatrix    = 1;
channels   = {'FITC\(WhiteTTL\)'};
useCluster = true;

% expFolder = '/n/regal/kleckner_lab/fchang/fcDataStorage/20209999-test';
 expFolder = '/n/regal/kleckner_lab/fchang/fcDataStorage/20170323-mitosis-FCY308';
tic;
procPart1(expFolder,'camVarFile',camVarFile,'Kmatrix',Kmatrix,'channels',channels,'useCluster',useCluster);
toc

%% test bulk modules
camVarFile               = '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';
Kmatrix                  = [1 0.31; 0 1];
channels                 = {'FITC\(WhiteTTL\)','mCherry\(WhiteTTL\)'};
useCluster               = false;

expFolder  = '~/Desktop/fcDataStorage/20160201-test-adf';
procPart1(expFolder,'camVarFile',camVarFile,'Kmatrix',Kmatrix,'channels',channels,'useCluster',useCluster);
procPart2(expFolder);
procPart3(expFolder);
%% build modules for 2 spot case and see if it generalizes to 1 spot case
% expFolder = '~/Dropbox/Public/smalldataset/fcDataStorage/20160201-test-adf';
camVarFile = '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';
camVarFile = '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat';
expFolder  = '~/Desktop/fcDataStorage/20160201-test-adf';
expFolder  = '~/Desktop/fcDataStorage/20150adsf';
expFolder  = '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20170323-mitosis-FCY308/doTimeLapse_1';
psfObj1 = genGaussKernObj([0.9,0.9,0.9],[7 7 7]);
psfObj2 = genGaussKernObj([1,1,1],[7 7 7]);

specimenUnitsInMicrons = [0.1083,0.1083,0.389];  % axial scaling factor included

psfObjs = {psfObj1,psfObj2};
Kmatrix = [1 0.31; 0 1];
channels = {'FITC\(WhiteTTL\)','mCherry\(WhiteTTL\)'};

psfObjs = {psfObj1};
Kmatrix = 1;
channels = {'FITC\(WhiteTTL\)'};

phaseOutputs        = procGetImages(expFolder,'BrightFieldTTL','phaseOutputs',specimenUnitsInMicrons);
spotOutputs         = procGetImages(expFolder,channels,'spotOutputs',specimenUnitsInMicrons);

qpmOutputs          = procQPMs(phaseOutputs,'negateQPM',false,'doProcParallel',true);
xyAlignments        = procXYAlignments(qpmOutputs,'imgTableName','genQPM1','doProcParallel',false);

stageIOutputs       = procStageI(spotOutputs,psfObjs,'Kmatrix',Kmatrix,'stageIFunc',@findSpotsStage1V2,'camVarFile',camVarFile,'doProcParallel',true);
maxColoredProjs     = procProjectStageI(stageIOutputs,'projFunc',@maxColoredProj,'projFuncArg',{3});
xyMaxProjNDs        = procProjectStageI(stageIOutputs,'projFunc',@xyMaxProjND,'projFuncArg',{});

T_stageIOutputs     = procXYTranslate(xyAlignments,stageIOutputs,'doProcParallel',true);
T_maxColoredProjs   = procXYTranslate(xyAlignments,maxColoredProjs,'doProcParallel',true);
T_xyMaxProjNDs      = procXYTranslate(xyAlignments,xyMaxProjNDs,'doProcParallel',true);
T_qpmOutputs        = procXYTranslate(xyAlignments,qpmOutputs,'doProcParallel',true);
T_spotOutputs       = procXYTranslate(xyAlignments,spotOutputs,'doProcParallel',true);
T_phaseOutputs      = procXYTranslate(xyAlignments,phaseOutputs,'doProcParallel',true);

%-----USER-----------------------------------------------------------------
thresholdOutputs    = procSelectThreshold(stageIOutputs,'selectField','LLRatio');
T_edgeProfileZs     = procGetEdgeProfileZ(T_phaseOutputs,'end');
%--------------------------------------------------------------------------

cellMasks           = procThreshPhase(qpmOutputs,'thresholdFunc',@genMaskWOtsu,'phaseTableName','genQPM1','doProcParallel',true);
selectCands         = procSelectCandidates(stageIOutputs,thresholdOutputs,'cellMaskVariable','genMaskWOtsu1','cellMasks',cellMasks,'selectField','LLRatio','doProcParallel',true);
stageIIOutputs      = procStageII(stageIOutputs,selectCands,'doParallel',true);
T_stageIIOutputs    = procXYTranslateSpots(xyAlignments,stageIIOutputs);
T_yeastSegs         = procYeastSeg(T_phaseOutputs,T_qpmOutputs,T_edgeProfileZs,'doParallel',true,'doPlot',false);

eC_T_stageIOutputs  = procExtractCells(T_yeastSegs,T_stageIOutputs,'doParallel',true);
eC_T_qpmOutputs     = procExtractCells(T_yeastSegs,T_qpmOutputs,'doParallel',true);
eC_T_spotOutputs    = procExtractCells(T_yeastSegs,T_spotOutputs,'doParallel',true);

ec_T_stageIIOutputs = procExtractSpots(T_yeastSegs,T_stageIIOutputs);

%-----USER-----------------------------------------------------------------
spotThresholds      = procSpotThresholds(stageIIOutputs);
%--------------------------------------------------------------------------

trackedSpots        = procSpotTracking(ec_T_stageIIOutputs,'searchDist',20,'spotthresh',spotThresholds.thresholds);
ec_T_3Dviz          = proc3DViz(eC_T_spotOutputs,eC_T_stageIOutputs,ec_T_stageIIOutputs,eC_T_qpmOutputs,'spotthresh',spotThresholds.thresholds);
analyzedTracks      = procAnalyzeTracks(eC_T_spotOutputs,ec_T_3Dviz,trackedSpots);


%% build modules

% optimize psf


expFolder = {'/mnt/btrfs/fcDataStorage/fcNikon/fcData/20170703-highlabel-HaloSubtilius',...
            '/mnt/btrfs/fcDataStorage/fcNikon/fcData/20170703-lowlabel-HaloSubtilius'};
        
expFolder = '~/Dropbox/Public/testingmatlab/highLabel-Subtilius';
camVarFile = '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';

expFolder = {'~/Dropbox/Public/testingmatlab/highLabel-Subtilius/doTimeLapse_1'};
camVarFile = '~/Documents/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';

%expFolder = {'~/Dropbox/Public/testingmatlab/highLabel-Subtilius/doTimeLapse_1'};
%camVarFile = '~/Documents/MATLAB/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat';


% psfs and psfObjs
sigmaSQ = [0.9,0.9,0.9];
patchSize = [7 7 7];
psfObjs = {genGaussKernObj(sigmaSQ,patchSize)};
Kmatrix = 1;

% get camVar

qpmOutput       = procQPMs(expFolder,'BrightFieldTTL','negateQPM',true,'doProcParallel',true);
stageIOutputs   = procStageI(expFolder,{'WhiteTTL'},psfObjs,'Kmatrix',Kmatrix,'stageIFunc',@findSpotsStage1V2,'camVarFile',camVarFile,'doProcParallel',false);
coloredProjs   = procProjectStageI(stageIOutputs);
maxProjs       = procProjectStageI(stageIOutputs,'projFunc',@xyMaxProjND);

% selectThresh  = procSelectThreshold(stageIOutputs,'selectField','LLRatio');
selectCands    = procSelectCandidates(stageIOutputs,'selectField','LLRatio','fieldThresh',6.5879e+04,'doProcParallel',true);
stageIIOutputs = procStageII(stageIOutputs,selectCands);

estimated = findSpotsStage1V2(data,psfObj.returnShape,camVarFile);
estimated = fieldEstimator(data,psfObj.returnShape,camVarFile);
candidates = selectCandidates(estimated,'selectField','LLRatio','fieldThresh',1000);
MLEs = findSpotsStage2V2(data,camVarFile,estimated,candidates,1,psfObjs);



%% redo spot detection 
tic;
processSpots    = applyFuncTo_listOfListOfArguments(spotOutputs,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',300},@saveToProcessed_fcSpotDetection,{},'doParallel',false);
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
phaseOutputs      = getAllFiles(expFolder,phaseRegexp);
spotOutputs       = getAllFiles(expFolder,spotRegexp);
myLLRatio       = 800;%300;
calibrationFileList = {'~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat',...
                       '~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat',...
                       '~/Dropbox/code/Matlab/fcBinaries/origCameraCal20160410.mat'};
calibrationFile = calibrationFileList{3};

% convert list of files to listOfListOfArguments
phaseOutputs      = convertListToListofArguments(phaseOutputs);
spotOutputs       = convertListToListofArguments(spotOutputs);

processQPM      = applyFuncTo_listOfListOfArguments(phaseOutputs,@openImage_applyFuncTo,{},@genQPM,{},@saveToProcessed_images,{},'doParallel',true);
qpmImages       = groupByTimeLapses(processQPM.outputFiles);
qpmImages       = convertListToListofArguments(qpmImages);
save([expFolder filesep 'processingState']);

processSpots    = applyFuncTo_listOfListOfArguments(spotOutputs,@openImage_applyFuncTo,{},@fcSpotDetection,{'LLRatioThresh',myLLRatio,'pathToCalibration',calibrationFile},@saveToProcessed_fcSpotDetection,{},'doParallel',false);
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