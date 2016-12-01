%% building up v2
patchSize = [7 7 7];
kern = ndGauss([0.9,0.9,0.9],patchSize);
kernObj = myPattern_Numeric(kern);
domains = genMeshFromData(kern);
testTheta = [3 3 3];
maxThetas = [1 1 1];
plot3Dstack(kernObj.givenTheta(testTheta,domains))
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(testTheta,domains,maxThetas);

% multi spots
theta1 = [1 10 1 1 3];
theta2 = [1 6 5 5 3];
theta3 = [1 8 4 4 3];
bkgnd = 5;
buildThetas = {{kernObj,theta1},{kernObj,theta2},{kernObj,theta3},{bkgnd}};
buildMaxThetas = {[1 1 1],[1 1 1],[1 1 1]};
[genLambda,genDLambda,genD2Lambda] = genPatternsFromThetas(domains,buildThetas,buildMaxThetas);