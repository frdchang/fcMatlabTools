%% building up v2
patchSize = [7 7 7];
kern = ndGauss([0.9,0.9,0.9],patchSize);
kernObj = myPattern_Numeric(kern);
domains = genMeshFromData(kern);
testTheta = [3 3 3];
maxThetas = [1 1 1];
plot3Dstack(kernObj.givenTheta(domains,testTheta))
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,testTheta,maxThetas);

% multi spots
theta1 = [10 1 1 3];
theta2 = [6 5 5 3];
theta3 = [8 4 4 3];
bkgnd = 5;
k = 1;
buildThetas = {k,{kernObj,theta1},{kernObj,theta2},{kernObj,theta3},{bkgnd}};
buildMaxThetas = {1,[1 1 1],[1 1 1],[1 1 1]};
[genLambda,genDLambda,genD2Lambda] = littleLambda(domains,buildThetas,buildMaxThetas);