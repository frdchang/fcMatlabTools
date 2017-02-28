%% first find optimal gaussian size
stackpath = '/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/Image 36-subStack.tif';
stack = importStack(stackpath);
% the result is as follows
genSigmaLandscape(stack,genProcessedFileName(stackpath,'genSigmaLandscape'));

threshVal = 0.0015;
sigmaSQXY = 1:0.2:5;
sigmaSQZ  = 1:0.2:5;
XY = 3;
Z = 4;
patchSize = 30;
sigmaSQXY= sigmaSQXY(XY);
sigmaSQZ = sigmaSQZ(Z);
kern = ndGauss([sigmaSQXY,sigmaSQXY,sigmaSQZ],[patchSize,patchSize,patchSize]);
kern = threshPSF(kern,threshVal);
% sigmaSQXY = 1.4
% sigmaSQZ = 1.6
% usually i make kernel centered on odd number, but having it even number
% seems better.  will  look into it in the future

%% compare LLRatio given WLS versus PoissPoiss approx
kern = gpuArray(kern);
stack = gpuArray(stack);
cameraVariance = gpuArray(ones(size(stack)));
estimated = findSpotsStage1V2(stack,kern,cameraVariance);
imshow(cat(2,norm0to1(estimated.LLRatio{2}(:,:,9)),norm0to1(estimated.LLRatio{1}(:,:,9))),[]);
% this shows poisspoiss has better contrast use that

%% apply this to a folder
widefieldImages =  '/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-EpiRawFiles/';
myFiles         = getAllFiles(widefieldImages,'tif');
myFiles         = convertListToListofArguments(myFiles);
estimated       = applyFuncTo_listOfListOfArguments(myFiles,@openImage_applyFuncTo,{},@findSpotsStage1V2,{kern,[],'loadIntoGPU',true},@saveToProcessed_outputStruct,{[0 1 0 0 1 1]},'doParallel',false);

%% average all the SIM data to see effective brightness
simPath = '/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimRawFiles';
simFiles = getAllFiles(simPath,'lsm');
simFiles = convertListToListofArguments(simFiles);
summedSim = applyFuncTo_listOfListOfArguments(simFiles,@openImage_applyFuncTo,{},@sumSIMStack,{},@saveToProcessed_images,{},'doParallel',false);

%% separate out sim wf decon and average
procPath = '/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimDeconEpi';
procFiles = getAllFiles(procPath,'lsm');
procFiles = convertListToListofArguments(procFiles);
simDeconAvg = applyFuncTo_listOfListOfArguments(procFiles,@openImage_applyFuncTo,{},@inputPassThru,{},@saveToProcessed_cellOfImages,{},'doParallel',false);

%% extract 9th z-slice, the one in focus
% if sim stack, 11 slices, pluck out 4th slice
% if wf stack, 17 slices,  pluck out 9th slice
epiRawFiles = getAllFilesForApply('/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-EpiRawFiles');
myProcessedFiles =  getAllFilesForApply('/mnt/btrfs/fcProcessed/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-EpiRawFiles/[findSpotsStage1V2(5eUHPw)]');
SimDeconEpiFiles =  getAllFilesForApply('/mnt/btrfs/fcProcessed/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimDeconEpi/[inputPassThru]');
SumSimRawFiles = getAllFilesForApply( '/mnt/btrfs/fcProcessed/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimRawFiles/[sumSIMStack]');
simRawFiles = getAllFilesForApply('/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimRawFiles');
epiRawFiles = applyFuncTo_listOfListOfArguments(epiRawFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{9},@saveToProcessed_images,{},'doParallel',false);
myProcessedFiles = applyFuncTo_listOfListOfArguments(myProcessedFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{9},@saveToProcessed_images,{},'doParallel',false);

SimDeconEpiFiles = applyFuncTo_listOfListOfArguments(SimDeconEpiFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{4},@saveToProcessed_images,{},'doParallel',false);

SumSimRawFiles = applyFuncTo_listOfListOfArguments(SumSimRawFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{4},@saveToProcessed_images,{},'doParallel',false);
simRawFiles = applyFuncTo_listOfListOfArguments(simRawFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{4},@saveToProcessed_images,{},'doParallel',false);