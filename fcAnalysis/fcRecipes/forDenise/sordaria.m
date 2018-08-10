%% process 2 photon sordaria
% optimize psf for 2 photon
sampleImg = '/home/fchang/Dropbox/sordaria for fred/1016z 101513.tif';
sampleImg = importStack(sampleImg);
genSigmaLandscape(sampleImg,'~/Desktop/test');
% the parameters for the gaussian kernel.  should either be the PSF
% approximation or the width approximation of the chromosome.
expFolder       = '~/Dropbox/sordaria\ for\ fred';
%expFolder       = '~/Dropbox/sordaria\ for\ fred/ourNikonMeasurements';
gaussSigmaSqXY    = 13;
gaussSigmaSqZ    = 13;
patchSizeXY       = 31;
patchSizeZ       = 31;
threshVal = 0.015;
saveFolder      = 'processed';

% the path to the 3D tif file
tifFiles  = getAllFiles(expFolder,'tif');
tifFiles  = removeCertainStrings(tifFiles,'Bright');

% generate kernel
kern  = ndGauss([gaussSigmaSqXY,gaussSigmaSqXY,gaussSigmaSqZ],[patchSizeXY patchSizeXY patchSizeZ]);
 kern = threshPSF(kern,threshVal);
plot3Dstack(kern);
for ii = 1:numel(tifFiles)
    display(ii);
    stack = importStack(tifFiles{ii});
    est   = findSpotsStage1V2(stack,kern,ones(size(stack)));
    saveFile = [expFolder filesep saveFolder filesep returnFileName(tifFiles{ii})];
    saveFile = regexprep(saveFile,'\','');
    exportStack([saveFile '_LLRATIO'],est.LLRatio);
    exportStack([saveFile '_A1'],est.A1);
end

