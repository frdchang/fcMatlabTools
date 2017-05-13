benchStruct = genBenchMark('benchType',3);
benchStruct = procBenchMarkStageI(benchStruct);
benchStruct = procBenchMarkSelectCandidates(benchStruct);
benchStruct = procBenchMarkStageII(benchStruct);
analyzeStageI(benchStruct);
analyzeStageII(benchStruct);
