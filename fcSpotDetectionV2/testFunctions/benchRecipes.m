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


%% 1 spot
benchStruct = genBenchMark('benchType',1,'numSamples',10);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
benchStruct = procBenchMarkStageI(benchStruct,@logConv);
benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);
analyzeStageI(benchStruct,@logConv,'logConv');
analyzeStageI(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageI(benchStruct,@regularConv,'regularConv');

%% gamma fit test
benchStruct = genBenchMark('benchType',1,'numSamples',10000);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
analyzeStageI(benchStruct,@findSpotsStage1V2,'LLRatio','fitGamma',true);

%% do cramer rao test
timings = [];
tic;benchStruct = genBenchMark('benchType',3,'numSamples',100);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
timings(end+1) = toc;
tic;benchStruct = procBenchMarkStageII(benchStruct,'doN',100);
timings(end+1) = toc;
tic;analyzeStageIIvariance(benchStruct);
timings(end+1) = toc;
