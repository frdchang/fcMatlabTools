% compare the phase correlation that moerner uses versus llratio
testData = genSyntheticSpots();
est = findSpotsStage1V2(double(testData.data),testData.kernel,ones(size(testData.data)));
phaseCorr = phaseCorrelation(double(testData.data),testData.kernel);
plot3Dstack(catNorm(testData.synAmp,testData.data,est.LLRatio,phaseCorr));