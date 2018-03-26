%% 20170112 for talleys DV data
testPath = '/mnt/btrfs/fcDataStorage/fcCheckout/fromTalley/argosamples20160112/tifs/vert_resolution_test.tif';
test = importStack(testPath);
kern = ndGauss([0.9,0.9,0.9],[7,7,7]);
estimated = findSpotsStage1(test,kern,ones(size(test)));

% find focal plane by finding brightest mean 
maxInt = zeros(size(test,3),1);
for ii = 1:size(test,3)
   currPlane = test(:,:,ii);
   maxInt(ii) = max(currPlane(:));
end

% focal plane is z = 29

% remove negative values
estimated.A1(estimated.A1<0) = 0;
savePath= genProcessedFileName(testPath,@fredDeconFull3D);
exportSingleTifStack(savePath,norm2UINT255(estimated.A1));

