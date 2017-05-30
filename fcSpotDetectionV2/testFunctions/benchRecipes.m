%% to do
% -when 2 spots are separated by distance d, what is the ROC for that?
%

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

%% 2 spot 2 colors 
tic;
benchStruct = genBenchMark('benchType',3,'numSamples',10);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageIIDirect(benchStruct);
analyzeStageIIDirect(benchStruct);
toc

%% 1 spot
timings = [];
tic;benchStruct = genBenchMark('benchType',1,'numSamples',1000,'saveFolder','/mnt/btrfs/fcDataStorage/fcCheckout/');
timings(end+1) = toc;
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
timings(end+1) = toc;
benchStruct = procBenchMarkStageI(benchStruct,@logConv);
timings(end+1) = toc;
benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
timings(end+1) = toc;
benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
timings(end+1) = toc;
benchStruct = procBenchMarkStageI(benchStruct,@fieldEstimator);
timings(end+1) = toc;
benchStruct = procBenchMarkStageI(benchStruct,@llrpowered);
timings(end+1) = toc;
benchStruct = procBenchMarkStageI(benchStruct,@gammaCorrection);
timings(end+1) = toc;
analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
analyzeStageI(benchStruct,@logConv,'logConv');
analyzeStageI(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageI(benchStruct,@regularConv,'regularConv');
analyzeStageI(benchStruct,@fieldEstimator,'gradDOTLLRatio');
analyzeStageI(benchStruct,@llrpowered,'LLRatio2');
analyzeStageI(benchStruct,@llrpowered,'LLRatio3');
analyzeStageI(benchStruct,@llrpowered,'LLRatio4');
analyzeStageI(benchStruct,@llrpowered,'LLRatio5');
analyzeStageI(benchStruct,@llrpowered,'LLRatio20');
analyzeStageI(benchStruct,@gammaCorrection,'gammaSig');
analyzeStageI(benchStruct,@gammaCorrection,'negLoggammaSig');
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
timings = [];
tic;benchStruct = genBenchMark('benchType',1,'numSamples',2,'As',[1 3],'Bs',0);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageII(benchStruct,'doN',100);
timings(end+1) = toc;
tic;analyzeStageIIvariance(benchStruct);
timings(end+1) = toc;
