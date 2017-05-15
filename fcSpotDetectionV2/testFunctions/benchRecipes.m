benchStruct = genBenchMark('benchType',3,'numSamples',1000);
benchStruct = procBenchMarkStageI(benchStruct);
% benchStruct = procBenchMarkSelectCandidates(benchStruct);
benchStruct = procBenchMarkStageII(benchStruct);
% analyzeStageI(benchStruct);
% analyzeStageII(benchStruct);
