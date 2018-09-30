%% Generate a single spot example then solve it using stage I and stage II

% parameters to setup the single spot example
sizeData        = [29 29 11];  % size of the data we want to simulate
NoiseFunc       = @genSCMOSNoiseVar;   % noise model we will want to simulate
NoiseFuncArgs   = {sizeData,'scanType','slow'};    % and its parameters
A               = 20;  % intensity of PSF in (photon units)
B               = 2;   % intensity of background in (photon units)
centerCoor      = round(sizeData/2);   % position of PSF 
gaussSigmas     = [1 1 1];    % PSF approximated as gaussian
gaussSize       = [7 7 7];    % size of the PSF patch to use for stage I
psfObjs         = {genGaussKernObj(gaussSigmas,gaussSize)}; % psfs needs to be provided in a cell list.  (for multi color, each psf for each color will be a component in this list)
kern            = cellfun(@(x) genKernelFromSep(x.returnShape), psfObjs,'uni',0);
kern            = cellfun(@(x) x/max(x(:)),kern,'uni',0); % normalize maximum intensity of PSF to 1
Kmatrix         = 1;  % bleed through coefficient matrix



domains         = genMeshFromData(zeros(sizeData)); % define the domain that the data will sit on
spotCoors       = {{[A centerCoor],B}}; % the spot amplitude and corrdinate
plot3Dstack(cat(2,kern{:}),'text','spots');



camVar                       = NoiseFunc(NoiseFuncArgs{:});
[stack,~,cameraParams]       = genMicroscopeNoise(bigLambdas,'readNoiseData',camVar);
cameraVarianceInElectrons   = cameraParams.cameraVarianceInADU.*(cameraParams.gainElectronPerCount.^2);
plot3Dstack(cat(2,stack{:}),'text','noisy spot');



[~,photonData]      = returnElectrons(stack,cameraParams);
plot3Dstack(catNorm(photonData{:}),'text','measurement back to electrons');

%% Given the synthetic data above, find the spot and localize it using 
% Stagei and Stageii operations.

% parameters for stage I and stage II 
doPlotEveryN     = 5;
% stage I
estimated           = findSpotsStage1V2(photonData,kern,cameraVarianceInElectrons,'kMatrix',Kmatrix);
plot3Dstack(cat(1,cat(2,groundTruth{:}),cat(2,estimated.A1{:})));
% select candidates from stage I
candidates= selectCandidates(estimated);
% stage II
MLEs = findSpotsStage2V2(photonData,cameraVarianceInElectrons,estimated,candidates,Kmatrix,psfObjs,...
'doPlotEveryN',doPlotEveryN,'numSpots',1,'gradSteps',1000);


