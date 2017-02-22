%% for gfp and tdtomato on redGr filter cube i calculate the kmatrix to be
% greenTTL then cyanTTL for tdTomato then GFP . 20170220
clear;
Kmatrix = [1 0.3144; 0.0004 1];
greenTTL = '/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/green_red/BWY762_RG_6_w3-both(GreenTTL).tif';
cyanTTL = '/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/green_red/BWY762_RG_6_w3-both(CyanTTL).tif';
greenTTL = importStack(greenTTL);
cyanTTL = importStack(cyanTTL);



patchSize = [7 7 7];
sigmassq = [1,1,1];
% build the numeric multi emitter
[~,kern] = ndGauss(sigmassq,patchSize);


cameraCalibration2048x2048 = '/home/fchang/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat';
[greenTTL,cameraVars] = returnElectronsFromCalibrationFile(greenTTL,cameraCalibration2048x2048);
greenTTL = gpuArray(greenTTL);
kern = cellfunNonUniformOutput(@(x) gpuArray(x),kern);
cameraVars = gpuArray(cameraVars);
clear findSpotsStage1V2;
estimated = findSpotsStage1V2({greenTTL,cyanTTL},kern,cameraVars,Kmatrix');
%% lets try spectral bleedthru on real data
cameraCalibration2048x2048 = '/Users/fchang/Documents/MATLAB/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat';
patchSize = [7 7 7];
sigmassq = [1,1,1];
% build the numeric multi emitter
[~,kern] = ndGauss(sigmassq,patchSize);

bothFluors_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(GreenTTL).tif';
bothFluors_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(CyanTTL).tif';
bothFluors_greenTTL = importStack(bothFluors_greenTTL);
bothFluors_cyanTTL = importStack(bothFluors_cyanTTL);

Kmatrix = [1 0.45; 0.4785 1];
estimated = findSpotsStage1V2({bothFluors_greenTTL,bothFluors_cyanTTL},kern,cameraCalibration2048x2048,Kmatrix);
%% lets check real multi spectral dataset 
patchSize = [7 7 7];
sigmassq = [1,1,1];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
% first gfp only
gfp_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY769_GG/takeA3DStack/BWY769_GG_w3-both(GreenTTL).tif';
gfp_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY769_GG/takeA3DStack/BWY769_GG_w3-both(CyanTTL).tif';
gfp_greenTTL = importStack(gfp_greenTTL);
gfp_cyanTTL = importStack(gfp_cyanTTL);
gfp_greenTTL_Filtered = findSpotsStage1V2(gfp_greenTTL,kern,ones(size(gfp_greenTTL)));
gfp_cyanTTL_Filtered = findSpotsStage1V2(gfp_cyanTTL,kern,ones(size(gfp_cyanTTL)));
gfp_cyanTTL_LLRatio = gfp_cyanTTL_Filtered.LLRatio;
gfp_cyanTTL_LLRatio(gfp_cyanTTL_LLRatio<0)=0;
threshVal = multithresh(gfp_cyanTTL_LLRatio(:));
selectorLLRatio = gfp_cyanTTL_LLRatio > threshVal;
selectorPOSCyan = gfp_cyanTTL_Filtered.A1 > 0;
selectorPOSGreen = gfp_greenTTL_Filtered.A1 >0;
selector = selectorLLRatio.*selectorPOSCyan.*selectorPOSGreen;


% thresh = multithresh(gfp_cyanTTL(:))*2;
% selector = gfp_cyanTTL>thresh;
hold on;scatter(gfp_cyanTTL_Filtered.A1(selector>0),gfp_greenTTL_Filtered.A1(selector>0),'MarkerFaceColor','g','MarkerEdgeColor','g','MarkerEdgeAlpha',.01,'MarkerFaceAlpha',.01);
% first tdtomato only
tdTomato_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY770_RR/takeA3DStack/BWY770_RR_w3-both(GreenTTL).tif';
tdTomato_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY770_RR/takeA3DStack/BWY770_RR_w3-both(CyanTTL).tif';
tdTomato_greenTTL = importStack(tdTomato_greenTTL);
tdTomato_cyanTTL = importStack(tdTomato_cyanTTL);
% tdTomato_greenTTL = findSpotsStage1V2(tdTomato_greenTTL,kern,ones(size(tdTomato_greenTTL)));
% tdTomato_cyanTTL = findSpotsStage1V2(tdTomato_cyanTTL,kern,ones(size(tdTomato_cyanTTL)));

thresh = multithresh(tdTomato_greenTTL(:))*4;
selector = tdTomato_greenTTL>thresh;
hold on; 
scatter(tdTomato_greenTTL(selector),tdTomato_cyanTTL(selector),'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerEdgeAlpha',.003,'MarkerFaceAlpha',.003);

%% data with both datasets
bothFluors_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(GreenTTL).tif';
bothFluors_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(CyanTTL).tif';
bothFluors_greenTTL = importStack(bothFluors_greenTTL);
bothFluors_cyanTTL = importStack(bothFluors_cyanTTL);
thresh = multithresh(bothFluors_cyanTTL(:))*2;
selector = bothFluors_cyanTTL>thresh;
hold on; 
scatter(bothFluors_cyanTTL(selector),bothFluors_greenTTL(selector),'MarkerFaceColor','k','MarkerEdgeColor','k','MarkerEdgeAlpha',.1,'MarkerFaceAlpha',.1);


% lets try it on filtered datasets
bothFluors_greenTTL_F = findSpotsStage1V2(bothFluors_greenTTL,kern,ones(size(bothFluors_greenTTL)));
bothFluors_cyanTTL_F  = findSpotsStage1V2(bothFluors_cyanTTL,kern,ones(size(bothFluors_greenTTL)));
threshcyan = multithresh(bothFluors_cyanTTL_F.LLRatio(:));
threshgreen = multithresh(bothFluors_greenTTL_F.LLRatio(:));
selectorCyan = bothFluors_cyanTTL_F.LLRatio > threshcyan;
selectorGreen = bothFluors_greenTTL_F.LLRatio > threshgreen;
selector = selectorCyan.*selectorGreen.*(bothFluors_cyanTTL_F.A1>0).*(bothFluors_greenTTL_F.A1>0);
selector = selector>0;
scatter(datasample(bothFluors_cyanTTL(selector),1000),datasample(bothFluors_greenTTL(selector),1000),'k');
%% lets check multi dataset with multiple spots and see if i switch kmatrix order if it will affect calculation

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);

buildThetas1 = {{kernObj,[11 5 12 13]},{kernObj,[7 15 4 14]},{5}};
buildThetas2 = {{kernObj,[12 4 4 13]},{10}};
buildThetas3 = {{kernObj,[8 15 12 10]},{6}};
Kmatrix      = [1 0.2 0.4;0.5,1, 0.2;0.6,0.1 1];
thetaInputs2 = {buildThetas1,buildThetas2,buildThetas3};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);
estimated = findSpotsStage1V2(bigLambdas,kern, ones(size(bigLambdas{1})),Kmatrix);
%% %% lets check multi dataset - it checks out for Kmatrix 

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);



buildThetas1 = {{kernObj,[11  10    11    13]},{5}};
buildThetas2 = {{kernObj,[2  10    11    13]},{10}};
Kmatrix      = [1 0.2;0.5,1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);

estimated = findSpotsStage1V2(bigLambdas,kern, ones(size(bigLambdas{1})),Kmatrix);


%% lets check a fill pipeline LL1 is tested
patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);


sigmasq  = ones(size(testData));

estimated1 = findSpotsStage1V2(kern+rand(size(kern)),kern,sigmasq);
estimated1 = findSpotsStage1V2({testData},kern,sigmasq);
estimated2 = findSpotsStage1V2({testData,testData,testData},kern,sigmasq);


%% lets check multi dataset

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);



buildThetas1 = {{kernObj,[11 5.5 12.5 13.6]},{kernObj,[7 15.5 4.5 14.5]},{kernObj,[8.5 15.6 12.6 10.5]},{5.5}};
buildThetas2 = {{kernObj,[12 4.5 4.5 13]},{10}};
Kmatrix      = [1 0.2;0.2,1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};
buildMaxThetas1 = {[2 1 1 1],[2 1 1 1],[2 1 1 1],2};
buildMaxThetas2 = {[2 1 1 1],2};
kmatrixMax      = [0 0;0 0];
maxThetaInput = {buildMaxThetas1,buildMaxThetas2};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};

buildThetasTrue1 = {{kernObj,[10 5 12 13]},{kernObj,[6 15 5 15]},{kernObj,[8 15 12 10]},{5}};
buildThetasTrue2 = {{kernObj,[11 4 4 13]},{10}};
thetaInputsTrue = {buildThetasTrue1,buildThetasTrue2};
thetaInputsTrue = {Kmatrix,thetaInputsTrue{:}};



[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputsTrue);
sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end

[ newtonBuild ] = newtonRaphsonBuild(maxThetaInput);
state = MLEbyIterationV2(bigLambdas,thetaInputs2,sigmasqs,domains,{{maxThetaInput,1000},{newtonBuild,1000}},'doPlotEveryN',100);

%% lets do sanity check with one dataset version
patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);

buildThetas1 = {{kernObj,[10.5 6.6 11.3 13.5]},{kernObj,[6 15 5.2 15]},{kernObj,[8 15 12.7 10]},{5.5}};
Kmatrix      = 1;
thetaInputsPerturb = {buildThetas1};
thetaInputsPerturb = {Kmatrix,thetaInputsPerturb{:}};

trueThetas = {{kernObj,[10 5 12 13]},{kernObj,[6 15 5 15]},{kernObj,[8 15 12 10]},{5}};
thetaInputsTrue = {trueThetas};
thetaInputsTrue = {Kmatrix,thetaInputsTrue{:}};
buildMaxThetas = {0,{[2 1 1 1],[2 1 1 1],[2 1 1 1],2}};


[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputsTrue);
sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end
[ newtonBuild ] = newtonRaphsonBuild(buildMaxThetas);
state = MLEbyIterationV2(bigLambdas,thetaInputsPerturb,sigmasqs,domains,{{buildMaxThetas,1000},{newtonBuild,1000}},'doPlotEveryN',100);

%% check against MLEbyIteration original
%(data,theta0,readNoise,domains,varargin)
% [x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak] = deal(theta{:});
posx = 5;
posy = 12.1;
posz = 13;
sigmax = 6;
sigmay = 6;
sigmaz = 6;
amp = 10;
back = 5;
theta0 = [posx,posy,posz,sigmax,sigmay,sigmaz,amp,back];
theta0 = num2cell(theta0);
% flatten domains
datas = bigLambdas{1}(:);
state = MLEbyIteration(bigLambdas{1}(:),theta0,sigmasqs{1}(:),cellfunNonUniformOutput(@(x) x(:),domains),'type',2,'doPlotEveryN',10);


%% lets check mle by iteration v2

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);



buildThetas1 = {{kernObj,[10.1 5 12.1 13]},{kernObj,[6 15 5 15]},{kernObj,[8 15 12 10]},{5}};
buildThetas2 = {{kernObj,[5 12 10.1 13]},{10}};
Kmatrix      = [1 0.2;0.5,1];

thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};
%% lets test big lambda

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);


% spot in dataset 1
thetas1 = {[10 5 12 13],[6 15 5 15],[8 15 12 10]};
bkgnd1 = 5;
% spot in dataset 2
thetas2 = {[5 12 10 13]};
bkgnd2 = 10;

Kmatrix = [1 0.2;0.5,1];

buildThetas1 = {};
buildMaxThetas1 = {};
for ii = 1:numel(thetas1)
    buildThetas1{end+1} = {kernObj,thetas1{ii}};
    buildMaxThetas1{end+1} = [2 1 1 1];
end
buildThetas1{end+1} = {bkgnd1};
buildMaxThetas1{end+1} = 2;

buildThetas2 = {};
buildMaxThetas2 = {};
for ii = 1:numel(thetas2)
    buildThetas2{end+1} = {kernObj,thetas2{ii}};
    buildMaxThetas2{end+1} = [2 1 1 1];
end
buildThetas2{end+1} = {bkgnd2};
buildMaxThetas2{end+1} = 2;

thetaInputs = {buildThetas1,buildThetas2};
maxThetaInputs = {buildMaxThetas1,buildMaxThetas2};
maxKmatrix = [0 0; 0 0];
thetaInputs = {Kmatrix,thetaInputs{:}};
maxThetaInputs = {maxKmatrix,maxThetaInputs{:}};
[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs);
N = 100;

sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end

state = MLEbyIterationV2(bigLambdas,thetaInputs2,sigmasqs,domains,{{maxThetaInputs,N}});
%% testing color unmixing 
% need to test, but will work on n color unmixing first
cameraVariance = ones(size(bigLambdas{1}));
spotKern = threshPSF(kern,0.0015);
estimated1 = findSpotsStage1(bigLambdas{1},spotKern,cameraVariance);
estimated2 = findSpotsStage1(bigLambdas{2},spotKern,cameraVariance);
invKmatrix = inv(Kmatrix);

output1 = zeros(size(bigLambdas{1}));
output2 = zeros(size(bigLambdas{1}));
for ii = 1:numel(bigLambdas{1})
   test = invKmatrix*[estimated1.A1(ii);estimated2.A1(ii)];
   output1(ii) = test(1);
   output2(ii) = test(2);
end

%% build a single spot and compare with mathematica
% it matches with rms error of 10e-18, note i need to permute the
% dimensions [2 3 1] to match with mathematica
patchSize = [19 21 25];
sigmaSq   = [6,6,6];
testTheta = [9 8 7];
k = 1;
A = 1;
B = 0;
domains = genMeshFromData(ones(patchSize));
analyticThetaNaked = [testTheta,sigmaSq,A,B];
analyticLambda = k*lambda_single3DGauss(num2cell(analyticThetaNaked),domains,[1 1 1 0 0 0 0 0 ],0);
analyticLambda = permute(analyticLambda,[2 3 1]);
save('~/Desktop/matlabLambda','analyticLambda');

%% build a multi spot and compare with mathematica
% for mathematica need to permute [2 3 1]
% it matches 10e-18 when the numeric spot pattern does not move.
% when the pattern moves 0.5 pixels the rms error is 0.00324052
% when the pattern moves in the wrong 0.5 direction the rms error is 0.0261456


patchSize = [19 21 25];
sigmassq = [6,6,6];
% [amplitude x y z]
thetas = {[10 10 12 13],[6 15 11 15],[8 9 12 10]};
bkgnd = 5;
k = 0.2;

% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);
buildThetas = {k};
buildMaxThetas = {1};
for ii = 1:numel(thetas)
    buildThetas{end+1} = {kernObj,thetas{ii}};
    buildMaxThetas{end+1} = [1 1 1 1];
end
buildThetas{end+1} = {bkgnd};
buildMaxThetas{end+1} = 1;
[genLambda,genDLambda,genD2Lambda] = littleLambda(domains,buildThetas,buildMaxThetas);


% for mathematica convert scalar to scalar*ones(sizeData)
for ii = 1:numel(genDLambda)
   if isscalar(genDLambda{ii})
      genDLambda{ii} = genDLambda{ii}*ones(patchSize); 
   end
end

for ii = 1:numel(genD2Lambda)
   if isscalar(genD2Lambda{ii})
      genD2Lambda{ii} = genD2Lambda{ii}*ones(patchSize); 
   end
end

% for mathematica do corrections on dimension order
genLambda = permute(genLambda,[2 3 1]);
genDLambda = cellfunNonUniformOutput(@(x) permute(x,[2 3 1]),genDLambda);
genD2Lambda = cellfunNonUniformOutput(@(x) permute(x,[2 3 1]),genD2Lambda);

save('~/Desktop/genLambda.mat','genLambda');
save('~/Desktop/genDLambda.mat','genDLambda');
save('~/Desktop/genD2Lambda.mat','genD2Lambda');

%% build a spot and generating its derivatives
patchSize = [21 21 21];
kern = ndGauss([6,6,6],patchSize);
kernObj = myPattern_Numeric(kern);
domains = genMeshFromData(kern);
testTheta = [17 18 10];
maxThetas = [1 1 1];
plot3Dstack(kernObj.givenTheta(domains,testTheta))
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,testTheta,maxThetas);
analyticThetaNaked = [testTheta,6,6,6 10 5];
analyticLambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),0);
plot3Dstack(analyticLambda)
NDrms(lambdas,analyticLambda)
analyticDLambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,[1 1 1 0 0 0 0 0 ],1);
analyticD2Lambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,[1 1 1 0 0 0 0 0],2);
analyticDLambda = analyticDLambda(logical([1 1 1 0 0 0 0 0]));
analyticD2Lambda = analyticD2Lambda(logical([1 1 1 0 0 0 0 0]'*[1 1 1 0 0 0 0 0]));
NDrms(gradLambdas{1},analyticDLambda{1})
direction = {'x','y','z'};
for ii = 1:numel(gradLambdas)
   plot3Dstack(cat(1,gradLambdas{ii},analyticDLambda{ii}),'cbar',true,'projectionFunc',@maxextremumproj,'text',['(left: numeric, right: analytic 3D gaussian) d/d' direction{ii}]);
end

for ii = 1:numel(hessLambdas)
    [xx,yy] = ind2sub(size(hessLambdas),ii);
   plot3Dstack(cat(2,hessLambdas{ii},analyticD2Lambda{ii}),'cbar',true,'projectionFunc',@maxextremumproj,'text',['(left: numeric, right: analytic 3D gaussian) d2/d' direction{xx} 'd' direction{yy}]);
end
plot3Dstack(cat(2,lambdas,analyticLambda),'cbar',true,'projectionFunc',@maxextremumproj,'text','(left: numeric, right: analytic 3D gaussian) lambdas');


% multi spots
theta1 = [10 1.2 1 5.5];
theta2 = [6 5 5.87 2.2];
theta3 = [8 4.1 4.6 3.1];
bkgnd = 5;
k = 1;
buildThetas = {k,{kernObj,theta1},{kernObj,theta2},{kernObj,theta3},{bkgnd}};
% buildmaxthetas will always return dA
buildMaxThetas = {1,[1 1 1 1],[1 1 1 1],[1 1 1 1], 1};
[genLambda,genDLambda,genD2Lambda] = littleLambda(domains,buildThetas,buildMaxThetas);

%% check little lambda for correctness

% for mathematica need to permute [2 3 1]
patchSize = [19 21 25];
sigmassq = [6,6,6];

% [amplitude x y z]
thetas = {[10 11 11 11],[6 11 11 11],[8 11 11 11]};
bkgnd = 5;
k = 0.2;

% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);
buildThetas = {k};
buildMaxThetas = {1};
for ii = 1:numel(thetas)
    buildThetas{end+1} = {kernObj,thetas{ii}};
    buildMaxThetas{end+1} = [1 1 1 1];
end
buildThetas{end+1} = {bkgnd};
buildMaxThetas{end+1} = 1;
[genLambda,genDLambda,genD2Lambda] = littleLambda(domains,buildThetas,buildMaxThetas);

% build analytic multi emitter
analyticLambda = 0;
for ii = 1:numel(thetas)
    analyticThetaNaked = [thetas{ii}(2:end) sigmassq(:)' thetas{ii}(1) 0];
    analyticLambda = analyticLambda + lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),0);
end
analyticLambda = analyticLambda + bkgnd;
analyticLambda = k*analyticLambda;

% build analytic gradient multi emitter
analyticD = {};

analyticD{1} = analyticLambda/k;
for ii = 1:numel(thetas)
    currAmp =thetas{ii}(1);
    currXYZ = thetas{ii}(2:end);
    analyticThetaNaked = [currXYZ sigmassq(:)' 1 0];
    currLambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),0);
    currDs = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),1);
    
    % dlambda/da
    analyticD{end+1} = k*currLambda;
    analyticD = appendToCellOrArray(analyticD,cellfunNonUniformOutput(@(x) x*currAmp*k,currDs(1:3)));
end
analyticD{end+1} = k;

for ii = 1:numel(genDLambda)-1
 plot3Dstack(cat(2,genDLambda{ii},analyticD{ii}),'projectionFunc',@maxextremumproj)   
end





