%% process 2 photon sordaria
% optimize psf for 2 photon
sampleImg = '/Users/fchang/Dropbox/sordaria for fred/time series 1 71615 T=1.tif';
sampleImg = importStack(sampleImg);
genSigmaLandscape(sampleImg,'~/Desktop/test');
% the parameters for the gaussian kernel.  should either be the PSF
% approximation or the width approximation of the chromosome.
expFolder       = '/Users/fchang/Dropbox/sordaria\ for\ fred';
% expFolder       = '/Users/fchang/Dropbox/sordaria\ for\ fred/ourNikonMeasurements';
gaussSigmaSqXY    = 3;
gaussSigmaSqZ    = 1.5;
patchSizeXY       = 7;
patchSizeZ       = 7;

saveFolder      = 'processed';

% the path to the 3D tif file
tifFiles  = getAllFiles(expFolder,'tif');
tifFiles  = removeCertainStrings(tifFiles,'Bright');

% generate kernel
kern  = ndGauss([gaussSigmaSqXY,gaussSigmaSqXY,gaussSigmaSqZ],[patchSizeXY patchSizeXY patchSizeZ]);
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

