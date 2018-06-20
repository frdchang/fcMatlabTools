%% generate and then solve a six spot example
% cfp, egfp, yfp, morange, mapple, bodipy (503)

doPlotEveryN            = 4;

params.DLLDLambda       = @DLLDLambda_PoissPoiss;
params.sizeData         = [29 29 11];%[21 21 9];

params.psfFunc          = @genPSF;
params.binning          = 3;
params.psfFuncArgs      = { {'lambda',525e-9,'f',params.binning,'mode',0},...
                            {'lambda',550e-9,'f',params.binning,'mode',0},...
                            {'lambda',575e-9,'f',params.binning,'mode',0},...
                            {'lambda',600e-9,'f',params.binning,'mode',0},...
                            {'lambda',625e-9,'f',params.binning,'mode',0},...
                            {'lambda',650e-9,'f',params.binning,'mode',0}};
                        
params.interpMethod     = 'linear';
params.kMatrix          = [ 1 0.8 0.2 0 0 0; ...
                            0.2 1 0.5 0.1 0 0; ...
                            0 0.3 1 0.5 0 0; ...
                            0 0 0.2 1 0.6 0; ...
                            0 0 0 0.3 1 0.5; ...
                            0 0 0 0 0.3 1];

params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 1000;
params.As1              = 30;
params.As2              = 30;
params.Bs               = 2;
params.dist2Spots       = 2;

params.NoiseFuncArgs{1} = params.sizeData;
params.centerCoor       = round(params.sizeData/2);
centerCoor              = params.centerCoor;
Kmatrix                 = params.kMatrix;


psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[params.binning,params.binning,params.binning],'interpMethod',params.interpMethod),psfs);


% setup spot
domains     = genMeshFromData(zeros(params.sizeData));
secondCoor  = centerCoor+[params.dist2Spots 0 0];
spotCoors   = { {[params.As1 centerCoor],params.Bs},...
                {[params.As1 centerCoor],[params.As1 (centerCoor + [0 3 4])],params.Bs},...
                {[params.As1 centerCoor],params.Bs},...
                {[params.As1 centerCoor],[params.As1 (centerCoor + [3 3 1.5])],params.Bs},...
                {[params.As1 centerCoor],[params.As1 (centerCoor + [2 0.5 1])],[params.As1 (centerCoor - [1 2 2])],[params.As1 (centerCoor - [2 -3 0.5])],params.Bs},...
                {[params.As1 secondCoor],params.Bs},...
                };
% plot ground truth kmatrix = 1
bigTheta    = genBigTheta(eye(size(Kmatrix)),psfObjs,spotCoors);
[groundTruth,bigDLambdas,d2]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
plot3Dstack(catNorm(groundTruth{:}));
bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);
[bigLambdas,bigDLambdas,d2]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);

plot3Dstack(catNorm(bigLambdas{:}));


numSpots    = numSpotsInTheta(bigTheta);

MLEs = cell(params.numSamples,1);
sizeKern    = getPatchSize(psfs{1});

 camVar                       = params.NoiseFunc(params.NoiseFuncArgs{:});
 [stack,~,cameraParams]       = genMicroscopeNoise(bigLambdas,'readNoiseData',camVar);
cameraVarianceInElectrons   = cameraParams.cameraVarianceInADU.*(cameraParams.gainElectronPerCount.^2);
plot3Dstack(catNorm(stack{:}));

kern = cellfun(@(x) x.returnShape,psfObjs,'un',0);
kern = cellfun(@(x) threshPSF(x,[7,7,7]),kern,'un',0);
plot3Dstack(catNorm(kern{:}));

[~,photonData]      = returnElectrons(stack,cameraParams);
estimated           = findSpotsStage1V2(photonData,kern,cameraVarianceInElectrons,'kMatrix',Kmatrix);
plot3Dstack(catNorm(estimated.A1{:}));
plot3Dstack(estimated.LLRatio);

candidates= selectCandidates(estimated);
MLEs = findSpotsStage2V2(photonData,cameraVarianceInElectrons,estimated,candidates,Kmatrix,psfObjs,'doPlotEveryN',doPlotEveryN,'DLLDLambda',params.DLLDLambda);

    
