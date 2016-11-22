%% building up v2
patchSize = [7 7 7];
kern = ndGauss([0.9,0.9,0.9],patchSize);
kernObj = myPattern_Numeric(kern);
domains = genMeshFromData(kern);
testTheta = [3 3 3];
maxThetas = [1 1 1];
plot3Dstack(kernObj.givenTheta(testTheta,domains))
[gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(testTheta,domains,maxThetas);