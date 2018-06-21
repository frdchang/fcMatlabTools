%% process 2 photon sordaria

% the path to the 3D tif file
img = '/Users/frederickchang/Dropbox/sordaria for fred/Image1 black 101513.tif';

% the parameters for the gaussian kernel.  should either be the PSF
% approximation or the width approximation of the chromosome. 
gaussSigmaSq = 2;
patchSize = 9;

stack = importStack(img);
kern  = ndGauss([gaussSigmaSq,gaussSigmaSq,gaussSigmaSq],[patchSize patchSize patchSize]);
est   = findSpotsStage1V2(stack,kern,ones(size(stack)));

plot3Dstack(catNorm(stack,est.A1,est.LLRatio));
exportStack('~/Desktop/LLR_of_Sordaria',est.LLRatio);
exportStack('~/Desktop/A1_of_Sordaria',est.A1);
