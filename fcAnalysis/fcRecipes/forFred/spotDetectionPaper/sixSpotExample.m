%% generate and then solve a six spot example
% cfp, egfp, yfp, morange, mapple, bodipy (503)

doPlotEveryN            = 20;
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
params.kMatrix          = [ 1 0.7 0.1 0 0 0; ...
                            0.1 1 0.6 0.1 0 0; ...
                            0 0.1 1 0.3 0 0; ...
                            0 0 0.1 1 0.8 0; ...
                            0 0 0 0.1 1 0.3; ...
                            0 0 0 0 0.1 1];

params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 1000;
params.As1              = 12;
params.As2              = 30;
params.Bs               = 2;
params.dist2Spots       = 2;

params.NoiseFuncArgs{1} = params.sizeData;
params.centerCoor       = round(params.sizeData/2);
centerCoor              = params.centerCoor;
Kmatrix                 = params.kMatrix;


% psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
% psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
% psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[params.binning,params.binning,params.binning],'interpMethod',params.interpMethod),psfs);

params.psfFuncArgs = {{[1 1 1],[7 7 7]},...
                        {[1 1 1],[7 7 7]},...
                        {[1 1 1],[7 7 7]},...
                        {[1 1 1],[7 7 7]},...
                        {[1 1 1],[7 7 7]},...
                        {[1 1 1],[7 7 7]}};
psfObjs     = cellfunNonUniformOutput(@(x) genGaussKernObj(x{:}),params.psfFuncArgs);
kern        = cellfunNonUniformOutput(@(x) ndGauss(x{:}),params.psfFuncArgs);
% setup spot
domains     = genMeshFromData(zeros(params.sizeData));
secondCoor  = centerCoor+[params.dist2Spots 0 0];
spotCoors   = { {[params.As1 centerCoor],params.Bs},...
                {[params.As1 centerCoor],[params.As1 (centerCoor + [0 3 1])],params.Bs},...
                {[params.As1 centerCoor],params.Bs},...
                {[params.As1 centerCoor],[params.As1 (centerCoor - [4 1 1])],params.Bs},...
                {[params.As1 centerCoor],[params.As1 (centerCoor + [2 4 1])],[params.As1 (centerCoor - [0 2 1])],[params.As1 (centerCoor - [3 -2 1])],params.Bs},...
                {[params.As1 secondCoor],params.Bs},...
                };
           
                                         
% params.psfFuncArgs      = { {'lambda',525e-9,'f',params.binning,'mode',0},...
%                             {'lambda',550e-9,'f',params.binning,'mode',0}};   
                        
% kern = cellfun(@(x) x.returnShape,psfObjs,'un',0);
% kern = cellfun(@(x) threshPSF(x,[7,7,7]),kern,'un',0);
% kern = kern(1:2);
plot3Dstack(cat(2,kern{:}));


% plot ground truth kmatrix = 1
bigTheta    = genBigTheta(eye(size(Kmatrix)),psfObjs,spotCoors);
[groundTruth,~,~]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
plot3Dstack(cat(2,groundTruth{:}));
bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);
[bigLambdas,bigDLambdas,d2]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);

plot3Dstack(cat(2,bigLambdas{:}));


numSpots    = numSpotsInTheta(bigTheta);

MLEs = cell(params.numSamples,1);
sizeKern    = getPatchSize(kern{1});

 camVar                       = params.NoiseFunc(params.NoiseFuncArgs{:});
 [stack,~,cameraParams]       = genMicroscopeNoise(bigLambdas,'readNoiseData',camVar);
cameraVarianceInElectrons   = cameraParams.cameraVarianceInADU.*(cameraParams.gainElectronPerCount.^2);
plot3Dstack(catNorm(stack{:}));



[~,photonData]      = returnElectrons(stack,cameraParams);
estimated           = findSpotsStage1V2(photonData,kern,cameraVarianceInElectrons,'kMatrix',Kmatrix);
plot3Dstack(cat(2,estimated.A1{:}));
plot3Dstack(estimated.LLRatio);

candidates= selectCandidates(estimated);
MLEs = findSpotsStage2V2(photonData,cameraVarianceInElectrons,estimated,candidates,Kmatrix,psfObjs,'doPlotEveryN',doPlotEveryN,'DLLDLambda',params.DLLDLambda,'numSpots',numSpots);

lastMLE = MLEs{1}(12).thetaMLEs;
lastMLE = lastMLE(2:end);
spotsCoors = cellfunNonUniformOutput(@(x) x(1:end-1),lastMLE);

for ii = 1:numel(spotsCoors)
   trueSpots = spotCoors{ii};
   trueSpots = trueSpots(1:end-1);
   trueSpots = cell2mat(cellfun(@(x) x(2:4)',trueSpots,'un',0));
   currSpots = spotsCoors{ii};
   currSpots = cell2mat(cellfun(@(x) x{2}(2:4)',currSpots,'un',0))';
   currData = stack{ii};
   trueData = groundTruth{ii};
   currA1   = estimated.A1{ii};
   crossData = bigLambdas{ii};
   myChan = ['chan_' num2str(ii)];
   savePath = '~/Desktop/';
   
%    myTitle = ['raw_' myChan];
%    plot3Dstack(currData,'text',myTitle);
%    export_fig([savePath myTitle]);
%    close all;
%    
%    myTitle = ['crossData_' myChan];
%    plot3Dstack(crossData,'text',myTitle);
%       export_fig([savePath myTitle]);
%    close all;
%    
%    myTitle = ['MLEA1_' myChan];
%    plot3Dstack(currA1,'clustCent',currSpots','text',myTitle);
%          export_fig([savePath myTitle]);
%    close all;
   
   myTitle = ['groundTruth_' myChan];
   plot3Dstack(trueData,'clustCent',trueSpots,'text',myTitle);
      export_fig([savePath myTitle]);
   close all;
end

