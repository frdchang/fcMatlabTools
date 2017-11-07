saveFolder = '~/Desktop/fcDataStorage/';
N = 100;
benchStruct = genBenchMark('benchType',1,'numSamples',N,'dist2Spots',0,'saveFolder',saveFolder,'As',[10],'Bs',[16]);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
% benchStruct = procBenchMarkStageI(benchStruct,@logConv);
 benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
% benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
% benchStruct = procBenchMarkStageI(benchStruct,@gammaCorrection);


 analyzeStageIFPRPlot(benchStruct,@findSpotsStage1V2,'LLRatio');
% analyzeStageIFPR(benchStruct,@findSpotsStage1V2,'A1');
% analyzeStageIFPR(benchStruct,@logConv,'logConv');
% analyzeStageIFPR(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageIFPRPlot(benchStruct,@regularConv,'regularConv');
% analyzeStageIFPR(benchStruct,@gammaCorrection,'negLoggammaSig');
%% this is the final version