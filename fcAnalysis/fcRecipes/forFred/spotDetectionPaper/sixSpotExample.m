%% generate and then solve a six spot example
% cfp, egfp, yfp, morange, mapple, bodipy (503)

doPlotEveryN            = 4;

params.DLLDLambda       = @DLLDLambda_PoissPoiss;
params.sizeData         = [29 29 11];%[21 21 9];

params.psfFunc          = @genPSF;
params.binning          = 3;
params.psfFuncArgs      = { {'lambda',400e-9,'f',params.binning,'mode',0},...
                            {'lambda',450e-9,'f',params.binning,'mode',0},...
                            {'lambda',500e-9,'f',params.binning,'mode',0},...
                            {'lambda',550e-9,'f',params.binning,'mode',0},...
                            {'lambda',600e-9,'f',params.binning,'mode',0},...
                            {'lambda',650e-9,'f',params.binning,'mode',0}};
params.interpMethod     = 'linear';
params.kMatrix          = [ 1 0 0 0 0 0; ...
                            0 1 0 0 0 0; ...
                            0 0 1 0 0 0; ...
                            0 0 0 1 0 0; ...
                            0 0 0 0 1 0; ...
                            0 0 0 0 0 1];

params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 1000;
params.As1              = 15;
params.As2              = 30;
params.Bs               = 6;
params.dist2Spots       = 6;

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
spotCoors   = { {[params.As1 centerCoor],[params.As1 (centerCoor + [1 0.5 1])],[params.As1 (centerCoor - [0.5 1 1])],[params.As1 (centerCoor - [2 -2 0.5])],params.Bs},...
                {[params.As1 centerCoor],[params.As1 secondCoor],params.Bs},...
                {[params.As1 centerCoor],params.Bs},...
                {[params.As1 centerCoor],[params.As1 secondCoor],params.Bs},...
                {[params.As1 centerCoor],[params.As1 secondCoor],[params.As1 secondCoor],params.Bs},...
                {[params.As2 secondCoor],params.Bs},...
                };
            
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

kern = cellfunNonUniformOutput(@(x) threshPSF(x,[11 11 11]),psfs);
plot3Dstack(catNorm(kern{:}));

[~,photonData]              = returnElectrons(stack,cameraParams);
    estimated                   = findSpotsStage1V2(photonData,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
    
