%% process 2 photon sordaria
% the parameters for the gaussian kernel.  should either be the PSF
% approximation or the width approximation of the chromosome.
expFolder       = '/home/fchang/Dropbox/sordaria\ for\ fred';
gaussSigmaSqXY    = 2;
gaussSigmaSqZ    = 1;
patchSizeXY       = 9;
patchSizeZ       = 1;

saveFolder      = 'processed';

% the path to the 3D tif file
tifFiles  = getAllFiles(expFolder,'tif');

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

