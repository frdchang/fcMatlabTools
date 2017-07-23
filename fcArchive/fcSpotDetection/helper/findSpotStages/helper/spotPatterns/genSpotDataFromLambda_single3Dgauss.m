function kernel = genSpotDataFromLambda_single3Dgauss(sigmaXYsq,sigmaZsq,threshold)
%GENSPOTDATAFROMLAMBDA_SINGLE3DGAUSS will generate a 3d Gaussian spot
%pattern and crop according to smallest canvase > threshold

Xsize = ceil(sqrt(sigmaXYsq)*10);
Ysize = Xsize;
Zsize = ceil(sqrt(sigmaZsq)*10);

% make sure its odd
Xsize = Xsize + ~mod(Xsize,2);
Ysize = Xsize;
Zsize = Zsize + ~mod(Zsize,2);
[x,y,z] = meshgrid(1:Xsize,1:Ysize,1:Zsize);

lambdas = lambda_single3DGauss({ceil(Xsize/2),ceil(Ysize/2),ceil(Zsize/2),sigmaXYsq,sigmaXYsq,sigmaZsq,1,0},{x,y,z},[],0);

mask = lambdas>threshold;
stats = regionprops(mask);
kernel = getSubsetwBBoxND(lambdas,stats.BoundingBox);
end

