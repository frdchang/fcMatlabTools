% compare the phase correlation that moerner uses versus llratio
testData = genSyntheticSpots();
kern = threshPSF(testData.kernel,0.03);
est = findSpotsStage1V2(double(testData.data),kern,ones(size(testData.data)));
phaseCorr = phaseCorrelation(double(testData.data),testData.kernel);
plot3Dstack(catNorm(testData.synAmp,testData.data,est.LLRatio,phaseCorr));