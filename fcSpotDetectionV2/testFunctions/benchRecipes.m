%% check 2 channel versus 1 channel
saveFolder = '~/Desktop/dataStorage/fcDataStorage';
N = 100;
kMatrixclean        = [1 0.75; 0 1];
kMatrix             = [1 0.75; 0 1];

% benchStruct1        = genBenchMark('benchType',1,'numSamples',N,'As',20,'Bs',1,'dist2Spots',0,'saveFolder',saveFolder);
saveFolder = '~/Desktop/dataStorage/fcDataStorage';
benchStruct3clean   = genBenchMark('benchType',3,'numSamples',N,'As',20,'Bs',1,'dist2Spots',0,'kMatrix',kMatrixclean,'saveFolder',saveFolder);
saveFolder = '~/Desktop/dataStorage/fcDataStorageReversed';
benchStruct3        = genBenchMark('benchType',3,'numSamples',N,'As',20,'Bs',1,'dist2Spots',0,'kMatrix',kMatrix,'saveFolder',saveFolder);

benchStruct3.Kmatrix= kMatrix';

% benchStruct1        = procBenchMarkStageI(benchStruct1,@findSpotsStage1V2);
benchStruct3clean   = procBenchMarkStageI(benchStruct3clean,@findSpotsStage1V2);
benchStruct3        = procBenchMarkStageI(benchStruct3,@findSpotsStage1V2);

% analyzeStageI(benchStruct1,@findSpotsStage1V2,'LLRatio');
analyzeStageI(benchStruct3clean,@findSpotsStage1V2,'LLRatio');
analyzeStageI(benchStruct3,@findSpotsStage1V2,'LLRatio');

benchStruct = procBenchMarkStageIIDirect(benchStruct3,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
benchStruct = procBenchMarkStageIIDirect(benchStruct3clean,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);

%% only thing on cluster needed is the stage II analysis
saveFolder  = '/n/regal/kleckner_lab/fchang/fcDataStorage';
N           = 1000; %4000
workers     = 25;
myPaths     = getPathFromFunc();

wallTimeGEN  = '4-00:00:00'; % '4-00:00:00';
memoryGEN    = '5000';
wallTimeStg1 = '1-00:00:00';
memoryStg1   = '5000';
wallTimeStg2 = '05:00:00';
memoryStg2   = '1800';

c = setupCluster('setWallTime', wallTimeGEN,'setMemUsage',memoryGEN);
funcArgs = {'benchType',3,'numSamples',N,'saveFolder',saveFolder};
j = c.batch(@genBenchMark, 1, funcArgs, 'pool',workers);
wait(j);
disp('do stageI');
funcArgs = {j.fetchOutputs{1},@findSpotsStage1V2};
clearCluster();
c = setupCluster('setWallTime',wallTimeStg1 ,'setMemUsage',memoryStg1);
j = c.batch(@procBenchMarkStageI,1,funcArgs,'pool',workers,'AdditionalPaths',myPaths);
wait(j);
disp('do stageII');
benchStruct = procBenchMarkStageIIDirectCluster(j.fetchOutputs{1},'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss,'setWallTime',wallTimeStg2,'setMemUsage',memoryStg2);
disp('analyze stageII');
analyzeStageIIDirect(benchStruct);
clearCluster();


% c = setupCluster('setWallTime', '1-00:00:00','setMemUsage','5000');
% funcArgs = {'benchType',2,'numSamples',N,'saveFolder',saveFolder};
% j1 = c.batch(@genBenchMark, 1, funcArgs, 'pool',workers);
% wait(j1);
% 
% c = setupCluster('setWallTime', '01:00:00','setMemUsage','5000');
% funcArgs = {'benchType',1,'numSamples',N,'saveFolder',saveFolder};
% j2 = c.batch(@genBenchMark, 1, funcArgs, 'pool',workers);
% wait(j2);
% 
% clearCluster();
% 
% c = parcluster;
% 
% % benchStruct1S1C = load('/n/regal/kleckner_lab/fchang/fcDataStorage/20170915-gBM-1S1C-N1000-sz_29 29 11_-A0,30,11-B0,24,5-D0,0,1-K1/1S1C/benchStruct.mat');
% funcArgs = {benchStruct1S1C.benchStruct,@findSpotsStage1V2};
% setupCluster('setWallTime', '04:00:00','setMemUsage','10000');
% j3 = c.batch(@procBenchMarkStageI,1,funcArgs,'pool',workers,'AdditionalPaths',myPaths);
% 
% % benchStruct2S1C = load('/n/regal/kleckner_lab/fchang/fcDataStorage/20170915-gBM-2S1C-N1000-sz_29 29 11_-A0,30,11-B0,24,5-D0,6,7-K1/2S1C/benchStruct.mat');
% 
% funcArgs = {benchStruct2S1C.benchStruct,@findSpotsStage1V2};
% j4 = c.batch(@procBenchMarkStageI,1,funcArgs,'pool',workers,'AdditionalPaths',myPaths);
% 
% % benchStruct2S2C = load('/n/regal/kleckner_lab/fchang/fcDataStorage/20170915-gBM-2S2C-N1000-sz_29 29 11_-A0,30,11-B0,24,5-D0,6,7-K0,0.3144/2S2C/benchStruct.mat');
% funcArgs = {benchStruct2S2C.benchStruct,@findSpotsStage1V2};
% j5 = c.batch(@procBenchMarkStageI,1,funcArgs,'pool',workers,'AdditionalPaths',myPaths);
% 
% clearCluster();
% benchStruct1S1C = load('/n/regal/kleckner_lab/fchang/fcProcessed/20170915-gBM-1S1C-N1000-sz_29 29 11_-A0,30,11-B0,24,5-D0,0,1-K1/1S1C/benchStruct.mat');
% % setupCluster('setWallTime', '04:00:00','setMemUsage','20000');
% benchStruct = procBenchMarkStageIIDirectCluster(benchStruct1S1C.benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
% analyzeStageIIDirect(benchStruct);
% 
% clearCluster();
% benchStruct2S2C = load('/n/regal/kleckner_lab/fchang/fcProcessed/20170915-gBM-2S2C-N1000-sz_29 29 11_-A0,30,11-B0,24,5-D0,6,7-K0,0.3144/2S2C/benchStruct.mat');
% % setupCluster('setWallTime', '04:00:00','setMemUsage','20000');
% benchStruct = procBenchMarkStageIIDirectCluster(benchStruct2S2C.benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
% analyzeStageIIDirect(benchStruct);
% 
% clearCluster();
% benchStruct2S1C = load('/n/regal/kleckner_lab/fchang/fcProcessed/20170915-gBM-2S1C-N1000-sz_29 29 11_-A0,30,11-B0,24,5-D0,6,7-K1/2S1C/benchStruct.mat');
% % setupCluster('setWallTime', '04:00:00','setMemUsage','20000');
% benchStruct = procBenchMarkStageIIDirectCluster(benchStruct2S1C.benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
% analyzeStageIIDirect(benchStruct);
% 
% 
% toc
%% 1 spot
switch computer
    case 'MACI64'
        saveFolder = '~/Desktop/dataStorage/fcDataStorage';
        N = 10;
    case 'GLNXA64'
        saveFolder = '/mnt/btrfs/fcDataStorage/fcCheckout/';
        N = 1000;
    otherwise
        error('asdf');
end

for type = 1:3
    benchStruct = genBenchMark('benchType',type,'numSamples',N,'dist2Spots',0,'saveFolder',saveFolder);
    benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
    benchStruct = procBenchMarkStageI(benchStruct,@logConv);
    benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
    benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
    benchStruct = procBenchMarkStageI(benchStruct,@fieldEstimator);
    % benchStruct = procBenchMarkStageI(benchStruct,@llrpowered);
    benchStruct = procBenchMarkStageI(benchStruct,@gammaCorrection);
    
    analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
    analyzeStageI(benchStruct,@findSpotsStage1V2,'A1');
    analyzeStageI(benchStruct,@logConv,'logConv');
    analyzeStageI(benchStruct,@testTemplateMatching,'testTemplateMatching');
    analyzeStageI(benchStruct,@regularConv,'regularConv');
    analyzeStageI(benchStruct,@fieldEstimator,'gradDOTLLRatio');
    analyzeStageI(benchStruct,@fieldEstimator,'hessDOTLLRatio');
    analyzeStageI(benchStruct,@fieldEstimator,'gradHessDOTLLRatio');
    analyzeStageI(benchStruct,@fieldEstimator,'gradHessDOTGamma');
    
    % analyzeStageI(benchStruct,@llrpowered,'LLRatio2');
    % analyzeStageI(benchStruct,@llrpowered,'LLRatio3');
    % analyzeStageI(benchStruct,@llrpowered,'LLRatio4');
    % analyzeStageI(benchStruct,@llrpowered,'LLRatio5');
    % analyzeStageI(benchStruct,@llrpowered,'LLRatio20');
    % analyzeStageI(benchStruct,@gammaCorrection,'gammaSig');
    analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSig');
    % analyzeStageI(benchStruct,@gammaCorrection,'gammaSig2');
    % analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSig2');
    % analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSigP2');
    
    
    analyzeStageIDataOut(benchStruct,@conditions,'fileList');
    analyzeStageIDataOut(benchStruct,@findSpotsStage1V2,'LLRatio');
    analyzeStageIDataOut(benchStruct,@findSpotsStage1V2,'A1');
    analyzeStageIDataOut(benchStruct,@logConv,'logConv');
    analyzeStageIDataOut(benchStruct,@testTemplateMatching,'testTemplateMatching');
    analyzeStageIDataOut(benchStruct,@regularConv,'regularConv');
    analyzeStageIDataOut(benchStruct,@fieldEstimator,'gradDOTLLRatio');
    analyzeStageIDataOut(benchStruct,@fieldEstimator,'hessDOTLLRatio');
    analyzeStageIDataOut(benchStruct,@fieldEstimator,'gradHessDOTLLRatio');
    analyzeStageIDataOut(benchStruct,@fieldEstimator,'gradHessDOTGamma');
    
    % analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio2');
    % analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio3');
    % analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio4');
    % analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio5');
    % analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio20');
    % analyzeStageIDataOut(benchStruct,@gammaCorrection,'gammaSig');
    analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSig');
    % analyzeStageIDataOut(benchStruct,@gammaCorrection,'gammaSig2');
    % analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSig2');
    % analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSigP2');
    
end
%% 2 spot 2 colors see gamma fit
switch computer
    case 'MACI64'
        saveFolder = '~/Desktop/dataStorage/fcDataStorage';
        N = 1;
    case 'GLNXA64'
        saveFolder = '/mnt/btrfs/fcDataStorage/fcCheckout/';
        N = 1000;
    otherwise
        error('asdf');
end

benchStruct1 = genBenchMark('benchType',3,'dist2Spots',0,'sizeData',[37 21 9],'numSamples',N,'saveFolder',saveFolder);
benchStruct1 = procBenchMarkStageI(benchStruct1,@findSpotsStage1V2);
analyzeStageI(benchStruct1,@findSpotsStage1V2,'LLRatio','fitGamma',true);

benchStruct2 = genBenchMark('benchType',3,'dist2Spots',10,'sizeData',[37 21 9],'numSamples',N,'saveFolder',saveFolder);
benchStruct2 = procBenchMarkStageI(benchStruct2,@findSpotsStage1V2);
analyzeStageI(benchStruct2,@findSpotsStage1V2,'LLRatio','fitGamma',true);

% measure signal is ok for second case for separated spots.
% measure signal is ok for first case for overlapping spots and measure
% bkgnd is ok for this case for both.

%% 2 spot 2 colors
benchStruct = genBenchMark('benchType',3,'numSamples',1000);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageI(benchStruct,@logConv);
benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
analyzeStageI(benchStruct,@logConv,'logConv');
analyzeStageI(benchStruct,@testTemplateMatching,'testTemplateMatching');
% benchStruct = procBenchMarkSelectCandidates(benchStruct);
benchStruct = procBenchMarkStageII(benchStruct);
% analyzeStageI(benchStruct);
% analyzeStageII(benchStruct);
structOut = cellfunNonUniformOutput(@(x) x{1},benchStruct.directFitting{1}.MLEsByDirect);
LLPG  = cellfunNonUniformOutput(@(x) [x.logLikePG],structOut);
LLPP  = cellfunNonUniformOutput(@(x) [x.logLikePP],structOut);
MLEs  = cellfunNonUniformOutput(@(x) {structOut{1}.thetaMLEs},structOut);
%% check convergence
tic;
% benchStruct = genBenchMark('benchType',3,'numSamples',30,'As',linspace(0,12,5),'Bs',linspace(0,12,5),'dist2Spots',0);
benchStruct = genBenchMark('benchType',3,'numSamples',10,'As',1,'Bs',0,'dist2Spots',0,'binning',3,'interpMethod','linear');
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageIIDirect(benchStruct,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
benchStruct.directFitting{1}.MLEsByDirect{2}{1}
% analyzeStageIIDirect(benchStruct);
toc

%% 1 spot
switch computer
    case 'MACI64'
        saveFolder = '~/Desktop/dataStorage/fcDataStorage';
    case 'GLNXA64'
        saveFolder = '/mnt/btrfs/fcDataStorage/fcCheckout/';
    otherwise
        error('asdf');
end
benchStruct = genBenchMark('benchType',1,'As',linspace(0,6,11),'Bs',linspace(0,4.8,5),'numSamples',1000,'dist2Spots',0,'saveFolder',saveFolder);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageI(benchStruct,@logConv);
benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
benchStruct = procBenchMarkStageI(benchStruct,@fieldEstimator);
% benchStruct = procBenchMarkStageI(benchStruct,@llrpowered);
benchStruct = procBenchMarkStageI(benchStruct,@gammaCorrection);

analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
analyzeStageI(benchStruct,@findSpotsStage1V2,'A1');
analyzeStageI(benchStruct,@logConv,'logConv');
analyzeStageI(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageI(benchStruct,@regularConv,'regularConv');
% analyzeStageI(benchStruct,@fieldEstimator,'gradDOTLLRatio');
% analyzeStageI(benchStruct,@fieldEstimator,'hessDOTLLRatio');
analyzeStageI(benchStruct,@fieldEstimator,'gradHessDOTLLRatio');
% analyzeStageI(benchStruct,@llrpowered,'LLRatio2');
% analyzeStageI(benchStruct,@llrpowered,'LLRatio3');
% analyzeStageI(benchStruct,@llrpowered,'LLRatio4');
% analyzeStageI(benchStruct,@llrpowered,'LLRatio5');
% analyzeStageI(benchStruct,@llrpowered,'LLRatio20');
% analyzeStageI(benchStruct,@gammaCorrection,'gammaSig');
analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSig');
% analyzeStageI(benchStruct,@gammaCorrection,'gammaSig2');
% analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSig2');
% analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSigP2');


analyzeStageIDataOut(benchStruct,@conditions,'fileList');
analyzeStageIDataOut(benchStruct,@findSpotsStage1V2,'LLRatio');
analyzeStageIDataOut(benchStruct,@findSpotsStage1V2,'A1');
analyzeStageIDataOut(benchStruct,@logConv,'logConv');
analyzeStageIDataOut(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageIDataOut(benchStruct,@regularConv,'regularConv');
% analyzeStageIDataOut(benchStruct,@fieldEstimator,'gradDOTLLRatio');
% analyzeStageIDataOut(benchStruct,@fieldEstimator,'hessDOTLLRatio');
analyzeStageIDataOut(benchStruct,@fieldEstimator,'gradHessDOTLLRatio');
% analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio2');
% analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio3');
% analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio4');
% analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio5');
% analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio20');
% analyzeStageIDataOut(benchStruct,@gammaCorrection,'gammaSig');
analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSig');
% analyzeStageIDataOut(benchStruct,@gammaCorrection,'gammaSig2');
% analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSig2');
% analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSigP2');


%% test edge effects versus without and see bkgnd creep
switch computer
    case 'MACI64'
        saveFolder = '~/Desktop/dataStorage/fcDataStorage';
        N = 10;
    case 'GLNXA64'
        saveFolder = '/mnt/btrfs/fcDataStorage/fcCheckout/';
        N = 1000;
    otherwise
        error('asdf');
end

benchStruct1 = genBenchMark('benchType',1,'numSamples',N,'sizeData',[31,31,31],'saveFolder',saveFolder);
benchStruct1 = procBenchMarkStageI(benchStruct1,@gammaCorrection);
analyzeStageI(benchStruct1,@gammaCorrection,'negLoggammaSig','noEdgeEffects',true);
benchStruct1 = procBenchMarkStageI(benchStruct1,@fieldEstimator);
analyzeStageI(benchStruct1,@fieldEstimator,'gradDOTLLRatio','noEdgeEffects',true);
analyzeStageI(benchStruct1,@fieldEstimator,'hessDOTLLRatio','noEdgeEffects',true);
analyzeStageI(benchStruct1,@fieldEstimator,'gradHessDOTLLRatio','noEdgeEffects',true);
benchStruct1 = procBenchMarkStageI(benchStruct1,@regularConv);
analyzeStageI(benchStruct1,@regularConv,'regularConv','noEdgeEffects',true);
benchStruct1 = procBenchMarkStageI(benchStruct1,@logConv);
analyzeStageI(benchStruct1,@logConv,'logConv','noEdgeEffects',true);
benchStruct1 = procBenchMarkStageI(benchStruct1,@findSpotsStage1V2);
analyzeStageI(benchStruct1,@findSpotsStage1V2,'LLRatio','noEdgeEffects',true);
analyzeStageI(benchStruct1,@findSpotsStage1V2,'A1','noEdgeEffects',true);
benchStruct1 = procBenchMarkStageI(benchStruct1,@testTemplateMatching);
analyzeStageI(benchStruct1,@testTemplateMatching,'testTemplateMatching','noEdgeEffects',true);


benchStruct2 = genBenchMark('benchType',1,'numSamples',N,'sizeData',[15,15,9],'saveFolder',saveFolder);
benchStruct2 = procBenchMarkStageI(benchStruct2,@gammaCorrection);
analyzeStageI(benchStruct2,@gammaCorrection,'negLoggammaSig','noEdgeEffects',false);
benchStruct2 = procBenchMarkStageI(benchStruct2,@fieldEstimator);
analyzeStageI(benchStruct2,@fieldEstimator,'gradDOTLLRatio','noEdgeEffects',false);
analyzeStageI(benchStruct2,@fieldEstimator,'hessDOTLLRatio','noEdgeEffects',false);
analyzeStageI(benchStruct2,@fieldEstimator,'gradHessDOTLLRatio','noEdgeEffects',false);
benchStruct2 = procBenchMarkStageI(benchStruct2,@regularConv);
analyzeStageI(benchStruct2,@regularConv,'regularConv','noEdgeEffects',false);
benchStruct2 = procBenchMarkStageI(benchStruct2,@logConv);
analyzeStageI(benchStruct2,@logConv,'logConv','noEdgeEffects',false);
% benchStruct2 = procBenchMarkStageI(benchStruct2,@findSpotsStage1V2);
% analyzeStageI(benchStruct2,@findSpotsStage1V2,'LLRatio','noEdgeEffects',false);
analyzeStageI(benchStruct2,@findSpotsStage1V2,'A1','noEdgeEffects',false);
benchStruct2 = procBenchMarkStageI(benchStruct2,@testTemplateMatching);
analyzeStageI(benchStruct2,@testTemplateMatching,'testTemplateMatching','noEdgeEffects',false);


%% gamma fit test
benchStruct = genBenchMark('benchType',1,'numSamples',4000,'As',0,'Bs',linspace(0,9,10),'sizeData',[51,51,51],'threshPSFArgs',{[11,11,11]});
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
benchStruct = genBenchMark('benchType',1,'numSamples',4000,'As',0,'Bs',linspace(0,9,10),'sizeData',[51,51,51],'threshPSFArgs',{[9,9,9]});
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
benchStruct = genBenchMark('benchType',1,'numSamples',4000,'As',0,'Bs',linspace(0,9,10),'sizeData',[51,51,51],'threshPSFArgs',{[7,7,7]});
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);


%% do cramer rao test
switch computer
    case 'MACI64'
        saveFolder = '~/Desktop/dataStorage/fcDataStorage';
        N = 60;
    case 'GLNXA64'
        saveFolder = '/mnt/btrfs/fcDataStorage/fcCheckout/';
        N = 100;
    otherwise
        error('asdf');
end

benchStruct = genBenchMark('benchType',3,'numSamples',N,'saveFolder',saveFolder,'dist2Spots',[0 3 6]);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageIIDirect(benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
analyzeStageIIDirect(benchStruct);

benchStruct = genBenchMark('benchType',2,'numSamples',N,'saveFolder',saveFolder,'dist2Spots',[0 3 6]);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageIIDirect(benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
analyzeStageIIDirect(benchStruct);

benchStruct = genBenchMark('benchType',1,'numSamples',N,'saveFolder',saveFolder,'dist2Spots',[0 3 6]);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageIIDirect(benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
analyzeStageIIDirect(benchStruct);




