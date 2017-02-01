
%% lets do sanity check with one dataset version
patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);

buildThetas1 = {{kernObj,[10 5 12.1 13]},{5}};
Kmatrix      = 1;
thetaInputsPerturb = {buildThetas1};
thetaInputsPerturb = {Kmatrix,thetaInputsPerturb{:}};

trueThetas = {{kernObj,[10 5 12 13]},{5}};
thetaInputsTrue = {trueThetas};
thetaInputsTrue = {Kmatrix,thetaInputsTrue{:}};
buildMaxThetas = {0,{[2 2 2 2],2}};


[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputsTrue);
sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end

state = MLEbyIterationV2(bigLambdas,thetaInputsPerturb,sigmasqs,domains,{{buildMaxThetas,10}});

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





