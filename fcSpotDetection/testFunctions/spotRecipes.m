%% check broken pixel correction
% camera settings
sampleSpot                = genSyntheticSpots(...
    'useCase',1);
readNoiseData = repmat(lognrnd(1.6,1.1,size(sampleSpot.data(:,:,1))),[1 1 size(sampleSpot.data,3)]);
gain          = 2.1;     % ADU/electrons
offset        = 100;     % ADU units
QE            = 0.7;     
% % here is a single spot with parameters {xp,yp,zp,amp}, 
% spotParamStruct1.xp       = 0.45657e-6;          % (units m in specimen plane)
% spotParamStruct1.yp       = 0.12246e-6;          % (units m in specimen plane)
% spotParamStruct1.zp       = 0.113245e-6;         % (units m in specimen plane)
% spotParamStruct1.amp      = 7;                   % (number of electrons at peak)
background                = 5;
% % generate that spot 
% spotList                  = {spotParamStruct1};
%  sampleSpot                = genSyntheticSpots(...
%     'useCase',2,'spotList',spotList,'bkgndVal',background,'readNoise',readNoise,'gain',gain,'offset',offset,'QE',QE);

meanInt = 40;
sampleSpot                = genSyntheticSpots(...
    'useCase',1,'bkgndVal',background,'readNoise',readNoiseData,'gain',gain,'offset',offset,'QE',QE,'meanInt',meanInt);
% convert back to photons
[electronData,photonData] = returnElectrons(sampleSpot.data,gain,offset,QE);
% generate theta vector for that sample spot
theta = genThetaFromSynSpotStruct_for_single3DGauss(sampleSpot.synSpotList{1});
% generate domain of the sample spot
domains = genDomainFromSampleSpot(sampleSpot);

% setup spot info struct for spot detection
sigmaSqVector = cell2mat(theta(4:6));
sizeVector = [7 7 7];
kernel = ndGauss(sigmaSqVector,sizeVector);
% normalize kernele to peak height = 1
kernel = kernel / max(kernel(:));
spotInfo.spotData = kernel;
spotInfo.lambdaModel = @lambda_single3DGauss;
spotInfo.constThetaVals = sigmaSqVector;
spotInfo.constThetaSet = [0 0 0 1 1 1 0 0];

% spot detection
% estimated = findSpotsStage1(electronData,spotInfo.spotData,readNoiseData);
% plot3Dstack(estimated.LLRatio);
% plot3Dstack(sampleSpot.synAmp);
% plot3Dstack(readNoiseData);
% estimatedNAIVE = findSpotsStage1(electronData,spotInfo.spotData,1.6*ones(size(sampleSpot.data)));
% plot3Dstack(estimatedNAIVE.LLRatio);

% simulate spots many times and see what it looks like variable camera
% noise looks like
saveFolder = '~/Desktop/variableReadNoiseSim';
mkdir(saveFolder);
N = 100;
I = imread('rice.png');
breakNumPixels = 10;
truthData = sampleSpot.synAmp + sampleSpot.synBak;
selectPixel = randperm(numel(truthData));
selectPixel = selectPixel(1:breakNumPixels);
readNoiseData(selectPixel) = inf;
for i = 1:N
    sampledData = genMicroscopeNoise(truthData,'readNoise',readNoiseData,'gain',gain,'offset',offset,'QE',QE);
    % break the pixels
%     sampledData(selectPixel) =  100;
    [electronData,photonData] = returnElectrons(sampledData,gain,offset,QE);
    electronData(selectPixel) = 100;
    estimated = findSpotsStage1(electronData,spotInfo.spotData,readNoiseData);
    estimatedNAIVE = findSpotsStage1(electronData,spotInfo.spotData,1.6*ones(size(sampledData)));
    
    estimatedLLRatio = return3Views(estimated.LLRatio,-1);
    estimatedNAIVELLRatio = return3Views(estimatedNAIVE.LLRatio,-1);
    electronData = return3Views(electronData,-1);
    
    exportSingleFitsStack([saveFolder filesep 'electronData' num2str(i)],electronData);
    exportSingleFitsStack([saveFolder filesep 'estimatedNAIVELLRatio' num2str(i)],estimatedNAIVELLRatio);
    exportSingleFitsStack([saveFolder filesep 'estimatedLLRatio' num2str(i)],estimatedLLRatio);
end

% simulate many times and see how broken pixels look like
exportSingleFitsStack([saveFolder filesep 'truthData'],return3Views(sampleSpot.synAmp));
exportSingleFitsStack([saveFolder filesep 'readNoise'],return3Views(readNoiseData));


%% do spot detection
% camera settings
readNoise     = 1.0;     % electrons (sigma = rms)
gain          = 2.1;     % ADU/electrons
offset        = 100;     % ADU units
QE            = 0.7;     
% % here is a single spot with parameters {xp,yp,zp,amp}, 
% spotParamStruct1.xp       = 0.45657e-6;          % (units m in specimen plane)
% spotParamStruct1.yp       = 0.12246e-6;          % (units m in specimen plane)
% spotParamStruct1.zp       = 0.113245e-6;         % (units m in specimen plane)
% spotParamStruct1.amp      = 7;                   % (number of electrons at peak)
background                = 5;
% % generate that spot 
% spotList                  = {spotParamStruct1};
%  sampleSpot                = genSyntheticSpots(...
%     'useCase',2,'spotList',spotList,'bkgndVal',background,'readNoise',readNoise,'gain',gain,'offset',offset,'QE',QE);

meanInt = 10;
sampleSpot                = genSyntheticSpots(...
    'useCase',1,'bkgndVal',background,'readNoise',readNoise,'gain',gain,'offset',offset,'QE',QE,'meanInt',meanInt);
% convert back to photons
[electronData,photonData] = returnElectrons(sampleSpot.data,gain,offset,QE);
% generate theta vector for that sample spot
theta = genThetaFromSynSpotStruct_for_single3DGauss(sampleSpot.synSpotList{1});
% generate domain of the sample spot
domains = genDomainFromSampleSpot(sampleSpot);

% setup spot info struct for spot detection
sigmaSqVector = cell2mat(theta(4:6));
sizeVector = [7 7 7];
kernel = ndGauss(sigmaSqVector,sizeVector);
% normalize kernele to peak height = 1
kernel = kernel / max(kernel(:));
spotInfo.spotData = kernel;
spotInfo.lambdaModel = @lambda_single3DGauss;
spotInfo.constThetaVals = sigmaSqVector;
spotInfo.constThetaSet = [0 0 0 1 1 1 0 0];
readNoiseData = readNoise*ones(size(electronData));
% spot detection
spotParams = fcSpotDetection(electronData,spotInfo,readNoiseData);

%% test cramer rao bound
N = 10000;
% if you want to use user defined spots
spotParamStruct1.xp   = 0.45657e-6;  %(units m in specimen plane)
spotParamStruct1.yp   = 0.12246e-6;  %(units m in specimen plane)
spotParamStruct1.zp   = 0.113245e-6;  %(units m in specimen plane)
spotParamStruct1.amp  = 7;    %(number of electrons at peak)
spotList        = {spotParamStruct1};
test = genSyntheticSpots('useCase',2,'spotList',spotList);
% data holders
maskHolder = false(size(test.data,1),size(test.data,2),N);
numPixHolder = zeros(N,1);
otherHolder = cell(N,1);
statHolderForLoose = cell(N,1);
statHolderTight    = cell(N,1);
% generate ideal 7x7x7 candidate
BWmask = zeros(size(test.data));
BWmask(round(test.synSpotList{1}.xPixel),round(test.synSpotList{1}.yPixel),round(test.synSpotList{1}.zPixel)) = 1;
BWmask = imdilate(BWmask,strel('arbitrary',ones(7,7,7)));
stats1 = regionprops(BWmask,'PixelIdxList','PixelList');
candidates.BWmask   = BWmask;
candidates.stats    = stats1;
% generate spots
kernSize = [7,7,7];
gaussSigmas = [test.synSpotList{1}.sigmaxy,test.synSpotList{1}.sigmaxy,test.synSpotList{1}.sigmaz];
gaussKern = ndGauss(gaussSigmas,kernSize);
gaussKern = gaussKern / max(gaussKern(:));
% generate read noise
sigmasq = 1.6*ones(size(test.data));
% find spots
fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,N) '\n\n']);
tic;
parfor ii = 1:N
    fprintf('\b|\n');
    test = genSyntheticSpots('useCase',2,'spotList',spotList);
    [~, photons]= returnElectrons(test.data,2.1,100,0.7);
    % detect spots
    detected = findSpotsStage1(photons,gaussKern,sigmasq);
    candidatesSimple = findSpotsStage2(detected);
    maskHolder(:,:,ii) = maxintensityproj(candidates.BWmask,3);
    statHolderForLoose{ii} = findSpotsStage3(photons,gaussSigmas,sigmasq,detected,candidatesSimple,'doPloteveryN',inf);
    statHolderTight{ii} = findSpotsStage3(photons,gaussSigmas,sigmasq,detected,candidates,'doPloteveryN',inf);
end
toc
checkCramerRaoBound(statHolderForLoose,test.synSpotList{1},kernSize,sigmasq);

%% generic data generator
% generate data
% if you want to use user defined spots
spotParamStruct1.xp   = 0.45e-6;  %(units m in specimen plane)
spotParamStruct1.yp   = 0.12e-6;  %(units m in specimen plane)
spotParamStruct1.zp   = 0.11e-6;  %(units m in specimen plane)
spotParamStruct1.amp  = 7;    %(number of electrons at peak)
%spotParamStruct1.bak  = (will be assigned params.bkgndVal)
% spotList = {spotParamStruct1,spotParamStruct2,...};
spotList        = {spotParamStruct1};
test = genSyntheticSpots('useCase',2,'spotList',spotList);
[electrons, photons]= returnElectrons(test.data,2.1,100,0.7);
sigmasq = 1.6*ones(size(photons));
% generate spots
psfData = genPSF('onlyPSF',false,'plotProfiles',false);
gaussSigmas = psfData.gaussSigmas;
kernSize = [7,7,7];
gaussKern = ndGauss(gaussSigmas,kernSize);
gaussKern = gaussKern / max(gaussKern(:));
% detect spots
detected = findSpotsStage1(photons,gaussKern,sigmasq);
stats  = findSpotsStage3(photons,gaussSigmas,sigmasq,detected,candidates,'doPloteveryN',inf);
%% test cramer rao bound
N = 10000;
% if you want to use user defined spots
spotParamStruct1.xp   = 0.45657e-6;  %(units m in specimen plane)
spotParamStruct1.yp   = 0.12246e-6;  %(units m in specimen plane)
spotParamStruct1.zp   = 0.113245e-6;  %(units m in specimen plane)
spotParamStruct1.amp  = 100;    %(number of electrons at peak)
%spotParamStruct1.bak  = (will be assigned params.bkgndVal)
% spotList = {spotParamStruct1,spotParamStruct2,...};
spotList        = {spotParamStruct1};
thetaMLE = cell(N,1);
thetaVAR = cell(N,1);
LLMLE    = cell(N,1);
test = genSyntheticSpots('useCase',2,'spotList',spotList);
BWmask = zeros(size(test.data));
BWmask(round(test.synSpotList{1}.xPixel),round(test.synSpotList{1}.yPixel),round(test.synSpotList{1}.zPixel)) = 1;
BWmask = imdilate(BWmask,strel('arbitrary',ones(7,7,7)));
stats1 = regionprops(BWmask,'PixelIdxList','PixelList');
candidates.BWmask   = BWmask;
candidates.stats    = stats1;
tic;
fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,N) '\n\n']);
parfor ii = 1:N
    fprintf('\b|\n');
    test = genSyntheticSpots('useCase',2,'spotList',spotList);
    [electrons, photons]= returnElectrons(test.data,2.1,100,0.7);
    sigmasq = 1.6*ones(size(photons));
    % generate spots
    psfData = genPSF('onlyPSF',false,'plotProfiles',false);
    gaussSigmas = psfData.gaussSigmas;
    kernSize = [7,7,7];
    gaussKern = ndGauss(gaussSigmas,kernSize);
    gaussKern = gaussKern / max(gaussKern(:));
    % detect spots
    detected = findSpotsStage1(photons,gaussKern,sigmasq);
    %%%%%% candidates = the right stuff first
    stats  = findSpotsStage3(photons,gaussSigmas,sigmasq,detected,candidates,'doPloteveryN',inf,'type',3);
    % pluck out maximum logLike
    if ~isempty(stats)
        if ~isempty(stats{1}.thetaMLE)
            logLike = cellfun(@(x) x.logLike, stats);
            [~,maxI] = max(logLike);
            stats = stats{maxI};
            thetaMLE{ii} = stats.thetaMLE;
            thetaVAR{ii} = stats.thetaVar;
            LLMLE{ii}    = stats.logLike;
        end
    end
end
toc
LLRatios = real([LLMLE{:}]);
xPos = cellfun(@(x) x{1},thetaMLE(~findEmptyCells(thetaMLE)));
xVar = cellfun(@(x) x(1),thetaVAR(~findEmptyCells(thetaVAR)));
%% i want to know if Loglikelihood is better than Lap of gaussian.
% yup, it is.  -fc
N = 1200;
saveFolder = '~/Desktop/LOGvsLLRatio';
psfData = genPSF('onlyPSF',false,'plotProfiles',false);
gaussSigmas = psfData.gaussSigmas;
kernSize = [7,7,7];
gaussKern = ndGauss(gaussSigmas,kernSize);
gaussKern = gaussKern / max(gaussKern(:));
sigmasq = 1.6*ones(size(data));
logKern = LOG3D(psfData.gaussSigmas.^2,kernSize);
LOGVals = zeros(N,1);
LL1Vals = zeros(N,1);
LL0Vals = zeros(N,1);
AVals   = zeros(N,1);
LLRatioFull = zeros(N,1);

LOGVals0 = zeros(N,1);
LL1Vals0 = zeros(N,1);
LL0Vals0 = zeros(N,1);
AVals0   = zeros(N,1);
LLRatioFull0 = zeros(N,1);

noSpotCoors = {15,10,16};
mkdir(saveFolder);
tic;
parfor i = 1:N
    test = genSyntheticSpots('useCase',2);
    spotCoors = {test.synSpotList{1}.xPixel,test.synSpotList{1}.yPixel,test.synSpotList{1}.zPixel};
    data = returnElectrons(test.data,2.1,100,0.7);
    detected = findSpotsStage1(data,gaussKern,sigmasq);
    padData = padarray(data,size(logKern),'replicate');
    logData = unpadarray(convFFTND(padData,logKern),size(data));
    LLRatioFullData = nlfilter3D({data,sigmasq,detected.A1,detected.B1,detected.B0},kernSize,@calcLogLikeOfPatch_PoissPoiss,{gaussKern},-inf);
    fullLLResults = nlfilter3D({data,sigmasq,detected.A1,detected.B1,detected.B0},kernSize,@calcMLEOfPatch_PoissPoiss,{gaussKern,gaussSigmas},-inf);
    detectedRefined = findSpotsStage1refined(data,gaussKern,sigmasq,detected,gaussSigmas);
    % with spot
    LOGVals(i) = logData(spotCoors{:});
    LL1Vals(i) = detected.LL1(spotCoors{:});
    LL0Vals(i) = detected.LL0(spotCoors{:});
    AVals(i) = detected.A1(spotCoors{:});
    LLRatioFull(i) = LLRatioFullData(spotCoors{:});
    % without spot
    LOGVals0(i) = logData(noSpotCoors{:});
    LL1Vals0(i) = detected.LL1(noSpotCoors{:});
    LL0Vals0(i) = detected.LL0(noSpotCoors{:});
    AVals0(i) = detected.A1(noSpotCoors{:});
    LLRatioFull0(i) =  LLRatioFullData(noSpotCoors{:});
    % save images
    maxData = maxintensityproj(data,3);
    maxA    = maxintensityproj(detected.A1,3);
    maxLOG  = maxintensityproj(logData,3);
    maxLLratio = maxintensityproj(detected.LL1-detected.LL0,3);
    display(i)
    %     if mod(i,100)==0
    %         display([num2str(i) ' of ' num2str(N)])
    % %         fits_write([saveFolder filesep 'data' num2str(i) '.fits'],maxData);
    % %         fits_write([saveFolder filesep 'A' num2str(i) '.fits'],maxA);
    % %         fits_write([saveFolder filesep 'LOG' num2str(i) '.fits'],maxLOG);
    % %         fits_write([saveFolder filesep 'LLratio' num2str(i) '.fits'],maxLLratio);
    %     end
end
toc

LOGdatas = genROC('Laplacian of Gaussian',LOGVals,LOGVals0);
% Adatas = genROC('MLE of Amp',AVals,AVals0);
LLratiodatas = genROC('Log(LikelihoodRatio)',LL1Vals-LL0Vals,LL1Vals0-LL0Vals0);
LLratioFulldatas = genROC('Log(LikelihoodRatioFull)',LLRatioFull,LLRatioFull0);
%% test gradient ascent
test = genSyntheticSpots('useCase',2);
trueData = test.synAmp+test.synBak;
data = returnElectrons(test.data,2.1,100);
[x,y,z] = meshgrid(1:19,1:19,1:25);
domains = {x,y,z};
kern = ndGauss([0.9,0.9,0.9],[7,7,7]);
detected = findSpotsStage1(data,kern,1.6*ones(size(data)));
% filter stage 1 by likelihood

trueTheta = {test.synSpotList{1}.xPixel,test.synSpotList{1}.yPixel,test.synSpotList{1}.zPixel,0.9,0.9,0.9,test.synSpotList{1}.amp,test.synSpotList{1}.bak};
testTheta = {test.synSpotList{1}.xPixel+1,test.synSpotList{1}.yPixel+1,test.synSpotList{1}.zPixel+1,0.9,0.9,0.9,test.synSpotList{1}.amp-1,test.synSpotList{1}.bak+1};
readNoise = 1.6*ones(size(data));
state = MLEbyIteration(data,testTheta,readNoise,domains,3);


%% test simple example to see if gradient and hessian functions are reporting correctly
[x,y,z] = meshgrid(-10:0.1:10,0,0);
amp = 10;
bak = 4;
data = amp*normpdf(x,0,2)+bak;
domains = {x,y,z};
theta = {0,0,0,2,0,0,amp,bak};
readNoise = 1.6*ones(size(data));
params.stepSize     = 1;
params.numSteps     = 1000;
params.lambda       = @lambda_single3DGauss;
params.maxThetas    = [1 1 1 0 0 0 1 1];
params.DLLDTheta    = @DLLDTheta;
params.DLLDLambda   = @DLLDLambda_PoissPoiss;
params.LogLike      = @logLike_PoissPoiss;


% define gradient function
gradFunc = @(theta,data) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,theta,domains,params.maxThetas,1);
% define hessian function
hessFunc = @(theta,data) params.DLLDTheta(params.LogLike,params.DLLDLambda,params.lambda,data,readNoise,theta,domains,params.maxThetas,2);



%% test first stage MLE
% it returns the parameters inputed to simulate the microscope
N = 1000;
ABasket = zeros(N,1);
BBasket = zeros(N,1);
kern1 = genPSF();
for i = 1:N
    display(i);
    test = genSyntheticSpots('useCase',2);
    inElectrons = returnElectrons(test.data,2.1,100);
    detected = findSpotsStageOne((inElectrons)*(1/0.7),kern1,ones(size(test.data)));
    Aest = detected.A;
    Best = detected.B;
    ABasket(i) = max(Aest(:));
    BBasket(i) = max(Best(:));
end

%% test gradient ascent MLE
% generate synthetic data with 1 spot
test = genSyntheticSpots('useCase',2);
% find the coordinate of maximum intensity
startCoor = ind2subND(size(test.data),find(test.data == max(test.data(:))));
inElectrons = returnElectrons(test.data,2.1,100);
kern = genPSF('onlyPSF',false);
detectedWPSF = findSpotsStageOne((inElectrons)*(1/0.7),threshPSF(kern.glPSF,0.08),ones(size(test.data)));
detectedWGauss = findSpotsStageOne((inElectrons)*(1/0.7),threshPSF(kern.gaussKern,0.08),ones(size(test.data)));
Aest = detectedWPSF.A(startCoor{:});
Best = detectedWPSF.B(startCoor{:});
sqrtBest = sqrt(Best);



%% plot 3d gradient vector field using quiver3(x,y,z,u,v,w)
test = genSyntheticSpots('useCase',2);
inElectrons = returnElectrons(test.data,2.1,100);
inPhotons = (inElectrons)*(1/0.7);
kern = genPSF('onlyPSF',false);
detectedWPSF = findSpotsStageOne(inPhotons,threshPSF(kern.glPSF,0.08),ones(size(test.data)));
% find the coordinate of maximum intensity
startCoor = ind2subND(size(detectedWPSF.A),find(detectedWPSF.A == max(detectedWPSF.A(:))));
Aest = detectedWPSF.A(startCoor{:});
Best = detectedWPSF.B(startCoor{:});
kernSigmas = {kern.gaussSigmas(1),kern.gaussSigmas(2),kern.gaussSigmas(3)};
initParam = [Aest,Best,startCoor{:},kernSigmas{:}];
useParam = [1,1,1,1,1,0,0,0];
close all;
param = doGradientSearch(initParam,useParam,@DLogDTheta_Spot1,inPhotons,'maxIter',1000,'stepSize',.1);
plot3Dstack(detectedWPSF.A,'clustCent',[param(3);param(4);param(5)]);
% DLogDTheta = calcDLogDTheta(Aest,Best,startCoor,kernSigmas,inPhotons);
% sampling = 1:1:numel(test.data);
% basketGrad = {};
% basketCoor = {};
% zSlice = 5;
% index = 1;
% for i = 1:size(test.data,1)
%     for j = 1:size(test.data,2)
%         currCoor = {i,j,zSlice};
%         DLogDTheta = calcDLogDTheta(Aest,Best,currCoor,kernSigmas,inPhotons);
%         basketGrad{index} = DLogDTheta(3:5);
%         basketCoor{index} = [currCoor{:}]';
%         index = index+1;
%     end
% end
% basketCoor = cell2mat(basketCoor)';
% basketGrad = cell2mat(basketGrad)';
% imagesc(detectedWPSF.A(:,:,zSlice));
% colormap gray
% hold on;
% quiver(basketCoor(:,1),basketCoor(:,2),basketGrad(:,1),basketGrad(:,2),'sr','filled');
% quiver3(basketCoor(:,1),basketCoor(:,2),basketCoor(:,3),basketGrad(:,1),basketGrad(:,2),basketGrad(:,3),'sr','filled');

%% generate different SNR
kern = genPSF('onlyPSF',false);
As = 10:4:30;
for j = 1:1000
    index = 1;
    for i = As
        spotParamStruct1.xp   = .2e-6;  %(units m in specimen plane)
        spotParamStruct1.yp   = .1e-6;  %(units m in specimen plane)
        spotParamStruct1.zp   = 0e-6;  %(units m in specimen plane)
        spotParamStruct1.amp  = i;    %(number of electrons at peak)
        sampleData = genSyntheticSpots('useCase',2,'bkgndVal',10,'spotList',{spotParamStruct1});
        % convert to photons
        inElectrons = returnElectrons(sampleData.data,2.1,100);
        inPhotons = (inElectrons)*(1/0.7);
        % grab kernel
        kern = genPSF('onlyPSF',false);
        % do stage 1
        detectedWPSF = findSpotsStageOne(inPhotons,threshPSF(kern.glPSF,0.04),ones(size(sampleData.data)));
        % save them
        if index == 1
            catenated = cat(2,maxintensityproj(detectedWPSF.A,3),maxintensityproj(sampleData.synAmp,3),maxintensityproj(detectedWPSF.B,3),maxintensityproj(sampleData.synBak,3));
            datas = maxintensityproj(sampleData.data,3);
        else
            catenated = cat(1,catenated,cat(2,maxintensityproj(detectedWPSF.A,3),maxintensityproj(sampleData.synAmp,3),maxintensityproj(detectedWPSF.B,3),maxintensityproj(sampleData.synBak,3)));
            datas = cat(1,datas,maxintensityproj(sampleData.data,3));
        end
        index = index+1;
    end
    exportSingleTifStack(['~/Desktop/test/catenated' num2str(j)],uint8(round(catenated*10)));
    exportSingleTifStack(['~/Desktop/test/datas' num2str(j)],uint8(round(datas)));
end
% setup stage 2
startCoor = ind2subND(size(detectedWPSF.A),find(detectedWPSF.A == max(detectedWPSF.A(:))));
Aest = detectedWPSF.A(startCoor{:});
Best = detectedWPSF.B(startCoor{:});
kernSigmas = {kern.gaussSigmas(1),kern.gaussSigmas(2),kern.gaussSigmas(3)};
initParam = [Aest,Best,startCoor{:},kernSigmas{:}];
useParam = [1,1,1,1,1,0,0,0];
% do stage 2
param = doGradientSearch(initParam,useParam,@DLogDTheta_Spot1,inPhotons,'maxIter',10000,'stepSize',1);



%% thousand points of light
thresh = 10;
minVolume = 10;
kern = genPSF('onlyPSF',false);
kernSigmas = {kern.gaussSigmas(1),kern.gaussSigmas(2),kern.gaussSigmas(3)};
kern = threshPSF(kern.glPSF,0.04);
BBoxSize = size(kern);
% sampleData = genSyntheticSpots('useCase',1,'zSteps',40,'ru',150,'meanInt',21,'numSpots',100);
detectedWPSF = findSpotsStageOne(sampleData.data,kern,ones(size(sampleData.data)));
% find candidate spots
BWmask = detectedWPSF.A > thresh;
% make sure candidate spots have a certain volume
BWmask = bwareaopen(BWmask, minVolume,6);
stats = regionprops(BWmask);
% find iterative MLE for every candidate
clustCent = zeros(3,numel(stats));
for i = 1:numel(stats)
    curCorr = stats(i).Centroid;
    %     curData = getSubsetwCentroidANdBBoxSizeND(sampleData.data,curCorr,BBoxSize);
    %     curAest = getSubsetwCentroidANdBBoxSizeND(detectedWPSF.A,curCorr,BBoxSize);
    %     curBest = getSubsetwCentroidANdBBoxSizeND(detectedWPSF.B,curCorr,BBoxSize);
    %     startCoor = ind2subND(size(curAest),find(curAest == max(curAest(:))));
    %     Aest = curAest(startCoor{:});
    %     Best = curBest(startCoor{:});
    %     initParam = [Aest,Best,startCoor{:},kernSigmas{:}];
    %     useParam = [1,1,1,1,1,0,0,0];
    %     param = doGradientSearch(initParam,useParam,@DLogDTheta_Spot1,curData,'maxIter',2000,'stepSize',10,'plotFunc',[]);
    %     coorEst = param(3:5);
    %     plot3Dstack(detectedWPSF.A,'clustCent',curCorr([2,1,3])');
    clustCent(:,i) = curCorr([2,1,3])';
end

%% test speed of various approaches to dot products and formatting
clear
test = rand(100*100*20,8);
kern = rand(100*100*20,1);
tic
output = sum(bsxfun(@times,test,kern));
toc
test1 = cell(8,1);
for i = 1:8
    test1{i} = rand(100*100*20,1);
end

tic;
output = zeros(8,1);
for i =1:8
    output(i) = test1{i}'*kern;
end
toc

% cell array dot product is just as fast as the bsxfun approach...i think i
% will do that way since i can use scalars as well.

%% test passing by reference
test = rand(1000,1000,20);
A = test;
B = test;
C = test;
dataStruct.A = test;
dataStruct.B = test;
dataStruct.C = test;
tic;
for i = 1:10
    dataStruct = inPlace(dataStruct);
    dataStruct.A = dataStruct.A+1;
    dataStruct.B = dataStruct.B+2;
    dataStruct.C = dataStruct.C+3;
end
toc
tic;
[A1,B1,C1] = notInPlace(A,B,C);
[A2,B1,C1] = notInPlace(A1,B1,C1);
toc

%% testing function speed
tic;
for i = 1:1000
    if isempty(firstDerivatives)
    end
end
toc
