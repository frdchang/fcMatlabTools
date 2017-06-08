%% to do

%% 2 spot 2 colors see gamma fit
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
benchStruct = genBenchMark('benchType',1,'numSamples',2000,'saveFolder',saveFolder);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageI(benchStruct,@logConv);
benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
benchStruct = procBenchMarkStageI(benchStruct,@fieldEstimator);
benchStruct = procBenchMarkStageI(benchStruct,@llrpowered);
benchStruct = procBenchMarkStageI(benchStruct,@gammaCorrection);

analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
analyzeStageI(benchStruct,@findSpotsStage1V2,'A1');
analyzeStageI(benchStruct,@logConv,'logConv');
analyzeStageI(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageI(benchStruct,@regularConv,'regularConv');
analyzeStageI(benchStruct,@fieldEstimator,'gradDOTLLRatio');
analyzeStageI(benchStruct,@fieldEstimator,'hessDOTLLRatio');
analyzeStageI(benchStruct,@fieldEstimator,'gradHessDOTLLRatio');
analyzeStageI(benchStruct,@llrpowered,'LLRatio2');
analyzeStageI(benchStruct,@llrpowered,'LLRatio3');
analyzeStageI(benchStruct,@llrpowered,'LLRatio4');
analyzeStageI(benchStruct,@llrpowered,'LLRatio5');
analyzeStageI(benchStruct,@llrpowered,'LLRatio20');
analyzeStageI(benchStruct,@gammaCorrection,'gammaSig');
analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSig');
analyzeStageI(benchStruct,@gammaCorrection,'gammaSig2');
analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSig2');
analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSigP2');


analyzeStageIDataOut(benchStruct,@conditions,'fileList');
analyzeStageIDataOut(benchStruct,@findSpotsStage1V2,'LLRatio');
analyzeStageIDataOut(benchStruct,@findSpotsStage1V2,'A1');
analyzeStageIDataOut(benchStruct,@logConv,'logConv');
analyzeStageIDataOut(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageIDataOut(benchStruct,@regularConv,'regularConv');
analyzeStageIDataOut(benchStruct,@fieldEstimator,'gradDOTLLRatio');
analyzeStageIDataOut(benchStruct,@fieldEstimator,'hessDOTLLRatio');
analyzeStageIDataOut(benchStruct,@fieldEstimator,'gradHessDOTLLRatio');
analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio2');
analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio3');
analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio4');
analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio5');
analyzeStageIDataOut(benchStruct,@llrpowered,'LLRatio20');
analyzeStageIDataOut(benchStruct,@gammaCorrection,'gammaSig');
analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSig');
analyzeStageIDataOut(benchStruct,@gammaCorrection,'gammaSig2');
analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSig2');
analyzeStageIDataOut(benchStruct,@gammaCorrection,'negLoggammaSigP2');


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
benchStruct2 = procBenchMarkStageI(benchStruct2,@findSpotsStage1V2);
analyzeStageI(benchStruct2,@findSpotsStage1V2,'LLRatio','noEdgeEffects',false);
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
    case 'GLNXA64'
        saveFolder = '/mnt/btrfs/fcDataStorage/fcCheckout/';
    otherwise
   error('asdf');     
end
timings = [];
tic;benchStruct = genBenchMark('benchType',1,'numSamples',1000,'saveFolder',saveFolder);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageIIDirect(benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
timings(end+1) = toc;
tic;analyzeStageIIDirect(benchStruct);
timings(end+1) = toc;

timings = [];
tic;benchStruct = genBenchMark('benchType',1,'numSamples',1000,'saveFolder',saveFolder);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageIIDirect(benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissGauss);
timings(end+1) = toc;
tic;analyzeStageIIDirect(benchStruct);
timings(end+1) = toc;

timings = [];
tic;benchStruct = genBenchMark('benchType',2,'numSamples',2,'As',[5 7],'Bs',[0 2],'dist2Spots',[0 10],'dist2SpotsAtA',[],'dist2SpotsAtB',[],'saveFolder',saveFolder);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageIIDirect(benchStruct,'doN',inf,'doPlotEveryN',inf,'DLLDLambda',@DLLDLambda_PoissPoiss);
timings(end+1) = toc;
tic;analyzeStageIIDirect(benchStruct);
timings(end+1) = toc;


