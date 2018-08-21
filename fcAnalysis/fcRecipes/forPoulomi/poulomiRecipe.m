%% 2018 08 18
% Analyze Spot counts and intensity for Poulomi's sample dataset

%% load image and plot data
c1 = importStack('/Users/fchang/Desktop/fcDataStorage/poulomi/image_36_as_tifs/c1.tif');
c2 = importStack('/Users/fchang/Desktop/fcDataStorage/poulomi/image_36_as_tifs/c2.tif');

% plot 3d max intensity projects and then save the images to desktop
plot3Dstack(c1);
export_fig '~/Desktop/c1_maxZ.tif' -nocrop
plot3Dstack(c2);
export_fig '~/Desktop/c2_maxZ.tif' -nocrop

%% figure out the 3d gaussian shape

% from meta data in czi file
% Experiment|AcquisitionBlock|AcquisitionModeSetup|ScalingX #1 = 7.9365079365079358e-008
% Experiment|AcquisitionBlock|AcquisitionModeSetup|ScalingY #1 = 7.9365079365079358e-008
% Experiment|AcquisitionBlock|AcquisitionModeSetup|ScalingZ #1 = 1.0955102040816328e-007
% 
% Scaling|Distance|Value #1 = 3.9682539682539679e-008
% Scaling|Distance|Value #2 = 3.9682539682539679e-008
% Scaling|Distance|Value #3 = 1.0955102040816328e-007
%
% Voxel size: 0.0397x0.0397x0.1096 micron^3
voxelSize = [0.0397,0.0397,0.1096];
xySigma = 0.0809;
zSigma = 0.27499;
sigmaVectorInVoxelUnits = [xySigma,xySigma,zSigma]./voxelSize;
[psf,sepPsf] = ndGauss(sigmaVectorInVoxelUnits.^2,[20,20,31]);
exportStack('~/Desktop/myEstimatedGuassianPSF.tif',psf);

psfObjs     = {genGaussKernObj(sigmaVectorInVoxelUnits.^2,[21,21,31])};
psfs        = cellfun(@(x) x.returnShape,psfObjs,'uni',0);
psfs        = cellfun(@(x) threshPSF(x,[13,13,15]),psfs,'uni',0);
% estimated psf looks similar to experimental single molecule fish data

% do spot detection
% first apply stage I
estC1 = findSpotsStage1V2({c1},psfs,ones(size(c1)),'kMatrix',1);
estC2 = findSpotsStage1V2({c2},psfs,ones(size(c1)),'kMatrix',1);
% second, select candidate spots
selectCandidatesC1 = selectCandidates(estC1,'meanShiftSize',4,'Nsamples',3000,'minVol',50);
plotLabels(estC1.A1{1},selectCandidatesC1.L,'showTextLabels',false);

% selectCandidatesC2 = selectCandidates(estC2,'meanShiftSize',7,'fieldThresh',1442655351,'Nsamples',3000,'minVol',50);
% plotLabels(estC2.A1{1},selectCandidatesC2.L,'showTextLabels',false);

% third, apply stage II to get sub pixel localization
MLEs = findSpotsStage2V2({c1},ones(size(c1)),estC1,selectCandidatesC1,1,psfObjs,'doParallel',true);

% plot
spotThresh = getLLRdistribution(MLEs);
clustCent = mle2clustCent(MLEs,'spotthresh',spotThresh);
plot3Dstack(c1,'clustCent',clustCent,'cRange',[0,15000],'zStep',1);
export_fig '~/Desktop/detectedSpots' -nocrop

amplitudes = mle2Amp(MLEs,'spotthresh',spotThresh);
figure;histogram(amplitudes);
xlabel('amplitudes');
export_fig '~/Desktop/amplitudes' -nocrop


