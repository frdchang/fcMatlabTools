%% gen example noisy psf
% parameters for 2 spots setup
binning = 3;
params.sizeData         = [15 15 11];
params.centerCoor       = round(params.sizeData/2);

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{'lambda',514e-9,'f',binning,'mode',0},{'lambda',610e-9,'f',binning,'mode',0}};
params.threshPSFArgs    = {[20,20,20]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.As               = 15;
params.Bs               = 5;
params.dist2Spots       = 29;

cameraVar               = params.NoiseFunc(params.NoiseFuncArgs{:});
centerCoor              = params.centerCoor ;
psfs                    = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfs                    = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
psfObjs                 = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[binning,binning,binning]),psfs);
psfs                    = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs                    = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);

domains                 = genMeshFromData(zeros(params.sizeData));
% 1 spot setup

% plot signal and poisson signal
spotCoors = {{[params.As centerCoor],0}};
bigTheta    = genBigTheta(1,psfObjs,spotCoors);
bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
signalAvg = bigLambdas{1};
signalPoisson = poissrnd(signalAvg);
signalAvg = xyMaxProjND(signalAvg);
signalPoisson = xyMaxProjND(signalPoisson);
% plot bkgnd and poisson bkgnd
spotCoors = {{[0 centerCoor],params.Bs}};
bigTheta    = genBigTheta(1,psfObjs,spotCoors);
bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
bkgndAvg = bigLambdas{1};
bkgndPoisson = poissrnd(bkgndAvg);
bkgndAvg = xyMaxProjND(bkgndAvg);
bkgndPoisson = xyMaxProjND(bkgndPoisson);


% together
spotCoors = {{[params.As centerCoor],params.Bs}};
bigTheta    = genBigTheta(1,psfObjs,spotCoors);
bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
theBigLambda = bigLambdas{1};
[sampledData,poissonPart,cameraParams,camNoise] = genMicroscopeNoise(theBigLambda,'readNoiseData',cameraVar);
poissonPart = xyMaxProjND(poissonPart);
camNoise = xyMaxProjND(camNoise);
[~,photonData] = returnElectrons(sampledData,cameraParams);
photonData = xyMaxProjND(photonData);
exportStack('~/Desktop/signalAvg',signalAvg);
exportStack('~/Desktop/bkgndAvg',bkgndAvg);
exportStack('~/Desktop/signalPoisson',signalPoisson);
exportStack('~/Desktop/bkgndPoisson',bkgndPoisson);
exportStack('~/Desktop/poissonPart',poissonPart);
exportStack('~/Desktop/camNoise',camNoise);
exportStack('~/Desktop/photonData',photonData);





%% generate figure 2 - sketch of pipeline
% parameters for 2 spots setup
Kmatrix = [1 0.2; 0 1];
binning = 3;
params.sizeData         = [51 21 11];
params.centerCoor       = round(params.sizeData/2);

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{'lambda',514e-9,'f',binning,'mode',0},{'lambda',610e-9,'f',binning,'mode',0}};
params.threshPSFArgs    = {[20,20,20]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.As               = 30;
params.Bs               = 0;
params.dist2Spots       = 29;

cameraVar          = params.NoiseFunc(params.NoiseFuncArgs{:});

centerCoor = params.centerCoor ;
psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[binning,binning,binning]),psfs);
psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);

domains     = genMeshFromData(zeros(params.sizeData));
% secondCoor = centerCoor+[params.dist2Spots 0 0];
% spotCoors2spots = {{[params.As centerCoor],params.Bs},{[params.As secondCoor],params.Bs}};

% 1 spot setup

% secondCoor = centerCoor+[params.dist2Spots 0 0];
% spotCoors = {{[20 centerCoor],[20 secondCoor],params.Bs}};
% bigTheta    = genBigTheta(1,psfObjs,spotCoors);
% bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
%
% theBigLambda = bigLambdas{1} + bkgnd;
% [sampledData,~,cameraParams] = genMicroscopeNoise(theBigLambda,'readNoiseData',cameraVar);
% [~,photonData] = returnElectrons(sampledData,cameraParams);
%
% myData = photonData;
% psf = psfs{1};
% centerCoor = params.centerCoor;
%
% estimated = findSpotsStage1V2(myData,psf,cameraVar,'kMatrix',1,'nonNegativity',true);
% estimatedGamma = gammaCorrection(myData,psf,cameraVar,'kMatrix',1,'nonNegativity',false);
%
% plot3Dstack(theBigLambda);
% plot3Dstack(photonData);
% plot3Dstack(estimatedGamma.A1);
% plot3Dstack(estimatedGamma.LLRatio);
% plot3Dstack(estimatedGamma.negLoggammaSig);
% plot3Dstack(catNorm(estimated.LLRatio,estimatedGamma.LLRatio,estimatedGamma.negLoggammaSig));
% % prep data output
% signalXY = xyMaxExtremumProjND(bigLambdas{1});
% bkgndXY  = xyMaxExtremumProjND(bkgnd);
% photonsXY = xyMaxExtremumProjND(photonData);
% photonsXY(photonsXY<0) = 0;
% A1XY = xyMaxExtremumProjND(estimated.A1);
% B1XY = xyMaxExtremumProjND(estimated.B1);
% B0XY = xyMaxExtremumProjND(estimated.B0);
% LLRXY = xyMaxExtremumProjND(estimated.LLRatio);
% uberImage = cat(2,signalXY,bkgndXY,photonsXY,A1XY,B1XY,B0XY);
% exportStack('~/Desktop/sigBkgndPhotonsA1B1B0',norm2UINT255(uberImage));
% exportStack('~/Desktop/LLRatio',norm2UINT255(LLRXY));
%
% gamXY = estimatedGamma.negLoggammaSig;
% gamXY(gamXY==inf) = 100;
% gamXY = xyMaxExtremumProjND(gamXY);
% exportStack('~/Desktop/gamma',norm2UINT255(gamXY));
%
% % select candidates
% test = estimatedGamma;
% test.LLRatio(estimatedGamma.negLoggammaSig == inf) = 1000;
% candidates = selectCandidates(test,'LLRatioThresh',999);
% candLabel = xyMaxProjND(candidates.L);
% candLabel = label2rgb(candLabel,'lines','k');
% imwrite(candLabel,'~/Desktop/candidates.tif');
% % candidatesSep = selectCandidates(estimatedSep);
% %
% estimated = findSpotsStage1V2({myData},psfs(1),cameraVar,'kMatrix',1,'nonNegativity',true);
%
% MLEs = findSpotsStage2V2({myData},cameraVar,estimated,candidates,1,psfObjs(1),'doPlotEveryN',2,'numSpots',1);

% 2 spot 2 color setup
bkgndVal1 = 7;
bkgndVal2 = 3;
centerCoor = [8 11 6]+0.25;
bkgnd1 = zeros(params.sizeData);
bkgnd1(1:round(params.sizeData(1)/2),:,:) = 1;
smoothBKGNDKern = ndGauss([60,60,60],[70,70,70]);
smoothBKGNDKern = smoothBKGNDKern / sum(smoothBKGNDKern(:));
bkgnd1 = padarray(bkgnd1,[70,70,70],'replicate');
bkgnd1 = convFFTND(bkgnd1,smoothBKGNDKern);
bkgnd1 = unpadarray(bkgnd1,params.sizeData);

bkgnd2 = zeros(params.sizeData);
bkgnd2(round(params.sizeData(1)/2):end,:,:) = 1;
smoothBKGNDKern = ndGauss([60,60,60],[70,70,70]);
smoothBKGNDKern = smoothBKGNDKern / sum(smoothBKGNDKern(:));
bkgnd2 = padarray(bkgnd2,[70,70,70],'replicate');
bkgnd2 = convFFTND(bkgnd2,smoothBKGNDKern);
bkgnd2 = unpadarray(bkgnd2,params.sizeData);


secondCoor = centerCoor+[params.dist2Spots 0 0];
spotCoors = {{[params.As centerCoor],params.Bs},{[params.As secondCoor],params.Bs}};
bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);
bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
groundTruth = bigLambda(domains,genBigTheta([1 0; 0 1],psfObjs,spotCoors),'objKerns',psfObjs);
bigBigLambdas = bigLambdas;
bigBigLambdas{1} = bigLambdas{1} + bkgnd1*bkgndVal1;
bigBigLambdas{2} = bigLambdas{2} + bkgnd2*bkgndVal2;

[sampledData,~,cameraParams] = genMicroscopeNoise(bigBigLambdas,'readNoiseData',cameraVar);
[~,photonData] = returnElectrons(sampledData,cameraParams);

estimated = findSpotsStage1V2(photonData,psfs,cameraVar,'kMatrix',Kmatrix,'nonNegativity',false);
% estimatedGamma = gammaCorrection(photonData,psfs,cameraVar,'kMatrix',Kmatrix,'nonNegativity',true);
plot3Dstack(estimated.LLRatio);
plot3Dstack(cat(2,estimated.A1{:}));
plot3Dstack(cat(2,estimated.B1{:}));
plot3Dstack(cat(2,estimated.B0{:}));
uberImage = cat(2,groundTruth{1},groundTruth{2},bkgnd1*bkgndVal1,bkgnd2*bkgndVal2,bigLambdas{1},bigLambdas{2},...
    bigBigLambdas{1},bigBigLambdas{2},photonData{1},photonData{2},...
    estimated.A1{1},estimated.A1{2},estimated.B1{1},estimated.B1{2},estimated.B0{1},estimated.B0{2});
uberImage = xyMaxProjND(uberImage);
exportStack('~/Desktop/gtbkmixlambdaphotonA1B1B0',norm2UINT255(uberImage));
LLRXY = xyMaxProjND(estimated.LLRatio);
exportStack('~/Desktop/LLR',norm2UINT255(LLRXY));
 candidates = selectCandidates(estimated,'strategy','otsu');
candLabel = xyMaxProjND(candidates.L);
 candLabel = label2rgb(candLabel,'lines','k');
 imwrite(candLabel,'~/Desktop/candidates.tif');
MLEs = findSpotsStage2V2(photonData,cameraVar,estimated,candidates,Kmatrix,psfObjs,'doPlotEveryN',2,'numSpots',1);
%% generated by hand tuning the 3D to flat representation
% H = genVoxelPSF(psf,centerCoor);


