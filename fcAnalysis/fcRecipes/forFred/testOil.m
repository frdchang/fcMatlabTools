

cus_0p108 = importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180415-testingOil_REDGREEN-ABN2LDF_0p108/takeA3DStack/ABN2LDF_0p108_w5-mCherry(AllFourTTL).tif');
% 0p087
cus_0p1449 = importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180415-testingOil_REDGREEN-ABN2LDF_0p087/takeA3DStack/ABN2LDF_0p087_w5-mCherry(AllFourTTL).tif');
nikon_A= importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180415-testingOil_REDGREEN-nikon_A/takeA3DStack/nikon_A_w5-mCherry(AllFourTTL).tif');
% 0p05
cus_0p3141 = importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180415-testingOil_REDGREEN-ABN2LDF_0p05/takeA3DStack/ABN2LDF_0p05_w5-mCherry(AllFourTTL).tif');

[~,kern] = ndGauss([1 1 1],[7 7 7]);
cus_0p108 = findSpotsStage1V2(cus_0p108,kern,ones(size(cus_0p108)));
nikon_A = findSpotsStage1V2(nikon_A,kern,ones(size(nikon_A)));
cus_0p1449 = findSpotsStage1V2(cus_0p1449,kern,ones(size(cus_0p1449)));
cus_0p3141 = findSpotsStage1V2(cus_0p3141,kern,ones(size(cus_0p3141)));

minRange = 10;
maxRange = 50;

myThresh = threshold(maxintensityproj(cus_0p108.LLRatio,3));
idx_cus_0p108 = cus_0p108.LLRatio > myThresh;
idx_cus_0p108 = filterBWbySizeRange(idx_cus_0p108,minRange,maxRange);
A1_cus_0p108 = maxInEachBWRegion(idx_cus_0p108,cus_0p108.A1);

myThresh = threshold(maxintensityproj(nikon_A.LLRatio,3));
idx_nikon_A = nikon_A.LLRatio > myThresh;
idx_nikon_A = filterBWbySizeRange(idx_nikon_A,minRange,maxRange);
A1_nikon_A = maxInEachBWRegion(idx_nikon_A,nikon_A.A1);


myThresh = threshold(maxintensityproj(cus_0p1449.LLRatio,3));
idx_cus_0p1449 = cus_0p1449.LLRatio > myThresh;
idx_cus_0p1449 = filterBWbySizeRange(idx_cus_0p1449,minRange,maxRange);
A1_cus_0p1449 = maxInEachBWRegion(idx_cus_0p1449,cus_0p1449.A1);


myThresh = threshold(maxintensityproj(cus_0p3141.LLRatio,3));
idx_cus_0p3141 = cus_0p3141.LLRatio > myThresh;
idx_cus_0p3141 = filterBWbySizeRange(idx_cus_0p3141,minRange,maxRange);
A1_cus_0p3141 = maxInEachBWRegion(idx_cus_0p3141,cus_0p3141.A1);





h = histogram(cus_0p108.A1(idx_cus_0p108));h.DisplayStyle = 'stairs';
hold on;
h = histogram(nikon_A.A1(idx_nikon_A));h.DisplayStyle = 'stairs';
h = histogram(cus_0p1449.A1(idx_cus_0p1449));h.DisplayStyle = 'stairs';
h = histogram(cus_0p3141.A1(idx_cus_0p3141));h.DisplayStyle = 'stairs';
legend('0.108','nikon_A','0.087','0.05');

figure;
h = histogram(A1_cus_0p108);h.DisplayStyle = 'stairs';h.Normalization = 'pdf';
hold on;
h = histogram(A1_nikon_A);h.DisplayStyle = 'stairs';h.Normalization = 'pdf';
h = histogram(A1_cus_0p1449);h.DisplayStyle = 'stairs';h.Normalization = 'pdf';
h = histogram(A1_cus_0p3141);h.DisplayStyle = 'stairs';h.Normalization = 'pdf';
legend('0.108','nikon_A','0.087','0.05');
title('mcherry');
