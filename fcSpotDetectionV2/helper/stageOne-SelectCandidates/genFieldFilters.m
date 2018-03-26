function [gradientFieldFilters,hessFieldFilters,kerns] = genFieldFilters(sizeOfKern,largeKern)
%GENFIELDFILTERS will carve out the field filters
% to avoid edge effects when carving, provide a largeKern, which means the
% same kernel but with larger borders.  this should be centered as should
% be kern and the rest of the guys.  sizeOfKern is how it will be cropped.


patchSize   = size(largeKern);
domains     = genMeshFromData(largeKern);
kernObj     = myPattern_Numeric(largeKern);
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,getCenterCoor(patchSize),[1 1 1]);
kern        = cropCenterSize(lambdas,sizeOfKern);
kernDs      = cellfunNonUniformOutput(@(x)cropCenterSize(x,sizeOfKern),gradLambdas);
kernD2s     = cellfunNonUniformOutput(@(x)cropCenterSize(x,sizeOfKern),hessLambdas);

cameraVariance  = ones(size(largeKern));
estimated       = findSpotsStage1V2(largeKern,kern,cameraVariance);
fullHess        = calcFullHessianFilter(largeKern,estimated,kern,kernDs,kernD2s,cameraVariance);
fullGrads       = calcFullGradientFilter(largeKern,estimated,kern,kernDs,cameraVariance );

gradientFieldFilters = cellfunNonUniformOutput(@(x) cropCenterSize(x,sizeOfKern),fullGrads);
hessFieldFilters     = cellfunNonUniformOutput(@(x) cropCenterSize(x,sizeOfKern),fullHess);

kerns.kern = kern;
kerns.kernDs = kernDs;
kerns.kernD2s = kernD2s;