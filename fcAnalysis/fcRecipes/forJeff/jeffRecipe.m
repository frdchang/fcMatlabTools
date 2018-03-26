%% 20160109 prelim analysis for jeff
expFolder = '/mnt/btrfs/fcDataStorage/fcCheckout/jeffMoffit/ForFred20170109';
tifs = getAllFiles(expFolder,'tif');
sigma = [1.69, 1.69];
patchSize = [7 7];
kern = ndGauss(sigma.^2,patchSize);
kern = threshPSF(kern,0.0015);

for ii = 1:numel(tifs)
    display(ii);
   currTif = imread(tifs{ii});
   currNoise = ones(size(currTif));
   estimated = findSpotsStage1(double(currTif),kern,currNoise);
   Ampfile = genProcessedFileName(tifs{ii},@Amp);
   LLRatiofile = genProcessedFileName(tifs{ii},@LLRatio);
   exportSingleFitsStack(Ampfile,estimated.A1);
   exportSingleFitsStack(LLRatiofile,estimated.LLRatio);
end