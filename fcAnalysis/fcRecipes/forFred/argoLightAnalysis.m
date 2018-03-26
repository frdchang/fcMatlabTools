%% first find optimal gaussian size
stackpathhighSNR = '/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/Image 32-line678.tif';
stackpathlowSNR = '/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/Image 39-line678.tif';
stackGOOD = importStack(stackpathhighSNR);
stackBAD = importStack(stackpathlowSNR);
% the result is as follows
% remove first slice as the stage is screwed up
stackGOOD(:,:,1) = [];
stackBAD(:,:,1) = [];

genSigmaLandscape(stackBAD,genProcessedFileName(stackpathlowSNR,'genSigmaLandscape'));
genSigmaLandscape(stackGOOD,genProcessedFileName(stackpathhighSNR,'genSigmaLandscape'));
threshVal = 0.0015;
sigmaXY = sqrt(0.1:0.05:3);
sigmaZ  = sqrt(0.1:0.05:3);
XY = 23;
Z  = 23;
patchSize = 31;
sigmaSQXY= sigmaXY(XY)^2;
sigmaSQZ = sigmaZ(Z)^2;
kern = ndGauss([sigmaSQXY,sigmaSQXY,sigmaSQZ],[patchSize,patchSize,patchSize]);
kern = threshPSF(kern,threshVal);
plot3Dstack(kern);
% sigmaSQXY = 1.2
% sigmaSQZ = 1.2


%% compare LLRatio given WLS versus PoissPoiss approx
kern = gpuArray(kern);
stack = gpuArray(stack);
cameraVariance = gpuArray(ones(size(stack)));
estimated = findSpotsStage1V2(stack,kern,cameraVariance);
imshow(cat(2,norm0to1(estimated.LLRatio{2}(:,:,9)),norm0to1(estimated.LLRatio{1}(:,:,9))),[]);
% this shows poisspoiss has better contrast use that

%% apply this to a folder
widefieldImages =  '/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-EpiRawFiles/';
myFiles         = getAllFiles(widefieldImages,'lsm');
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
myProcessedFiles =  getAllFilesForApply('/mnt/btrfs/fcProcessed/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-EpiRawFiles/[findSpotsStage1V2(E217FA)]');
SimDeconEpiFiles =  getAllFilesForApply('/mnt/btrfs/fcProcessed/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimDeconEpi/[inputPassThru]');
SumSimRawFiles = getAllFilesForApply( '/mnt/btrfs/fcProcessed/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimRawFiles/[sumSIMStack]');
simRawFiles = getAllFilesForApply('/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-SimRawFiles');
deconOnEpiFiles = getAllFilesForApply('/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/ArgoLight-EpiDecon');


epiRawFiles = applyFuncTo_listOfListOfArguments(epiRawFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{9},@saveToProcessed_images,{},'doParallel',false);
myProcessedFiles = applyFuncTo_listOfListOfArguments(myProcessedFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{9},@saveToProcessed_images,{},'doParallel',false);

SimDeconEpiFiles = applyFuncTo_listOfListOfArguments(SimDeconEpiFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{4},@saveToProcessed_images,{},'doParallel',false);

SumSimRawFiles = applyFuncTo_listOfListOfArguments(SumSimRawFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{4},@saveToProcessed_images,{},'doParallel',false);
simRawFiles = applyFuncTo_listOfListOfArguments(simRawFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{4},@saveToProcessed_images,{},'doParallel',false);

deconOnEpiFiles = applyFuncTo_listOfListOfArguments(deconOnEpiFiles,@openImage_applyFuncTo,{},@pluckASliceOut,{9},@saveToProcessed_images,{},'doParallel',false);