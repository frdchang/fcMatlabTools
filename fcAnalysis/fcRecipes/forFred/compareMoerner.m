%% compare the phase correlation that moerner uses versus llrati

gaussianFilterSigma = 1.9;

testData = genSyntheticSpots();
kern = threshPSF(testData.kernel,[9 9 9]);
est = findSpotsStage1V2(double(testData.data),kern,ones(size(testData.data)));
phaseCorr = phaseCorrelation(double(testData.data),kern,gaussianFilterSigma);
plot3Dstack(catNorm(testData.synAmp,testData.data,est.LLRatio,phaseCorr));