%% build a spot and generating its derivatives
patchSize = [7 7 7];
kern = ndGauss([0.9,0.9,0.9],patchSize);
kernObj = myPattern_Numeric(kern);
domains = genMeshFromData(kern);
testTheta = [3 3 3];
maxThetas = [1 1 1];
plot3Dstack(kernObj.givenTheta(domains,testTheta))
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,testTheta,maxThetas);

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
patchSize = [21 21 21];
sigmas = [6,6,6];

% [amplitude x y z]
thetas = {[10 17 18 10],[6 8 8 8],[8 18 8 13]};
bkgnd = 5;
k = 0.2;

% build the numeric multi emitter
kern = ndGauss(sigmas,patchSize);
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
    analyticThetaNaked = [thetas{ii}(2:end) sigmas(:)' thetas{ii}(1) 0];
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
    analyticThetaNaked = [currXYZ sigmas(:)' currAmp 0];
    currLambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),0);
    currDs = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),1);
    
    % dlambda/da
    analyticD{end+1} = k*currLambda;
    analyticD = appendToCellOrArray(analyticD,cellfunNonUniformOutput(@(x) x*currAmp*k,currDs(1:3)));
end
analyticD{end+1} = k;




