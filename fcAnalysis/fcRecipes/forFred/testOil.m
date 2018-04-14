custom1 = importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180414-testingOil-ABN2LDF_0p1454_old_1/takeA3DStack/ABN2LDF_0p1454_old_1_w3-GFP(AllFourTTL).tif');
custom2 = importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180414-testingOil-custom_again/takeA3DStack/custom_again_w3-GFP(AllFourTTL).tif');
nikon1= importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180414-testingOil-nikon_A_2/takeA3DStack/nikon_A_2_w3-GFP(AllFourTTL).tif');
ldf = importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180414-testingOil-LDF_1/takeA3DStack/LDF_1_w3-GFP(AllFourTTL).tif');
fresh = importStack('/mnt/btrfs/fcDataStorage/fcNikon/fcData/20180414-testingOil/20180414-testingOil-fresh_custom/takeA3DStack/fresh_custom_w3-GFP(AllFourTTL).tif');

kern = ndGauss([1 1 1],[7 7 7]);
cus = findSpotsStage1V2(custom1,kern,ones(size(custom1)));
nik = findSpotsStage1V2(nikon1,kern,ones(size(nikon1)));
cus2 = findSpotsStage1V2(custom2,kern,ones(size(custom1)));
ldf = findSpotsStage1V2(ldf,kern,ones(size(custom1)));
fresh = findSpotsStage1V2(fresh,kern,ones(size(custom1)));

myThresh = threshold(maxintensityproj(cus.LLRatio,3));
idx_cus = cus.LLRatio > myThresh;
myThresh = threshold(maxintensityproj(nik.LLRatio,3));
idx_nik = nik.LLRatio > myThresh;
myThresh = threshold(maxintensityproj(cus2.LLRatio,3));
idx_cus2 = cus2.LLRatio > myThresh;
myThresh = threshold(maxintensityproj(ldf.LLRatio,3));
idx_ldf = ldf.LLRatio > myThresh;
myThresh = threshold(maxintensityproj(fresh.LLRatio,3));
idx_fresh = fresh.LLRatio > myThresh;



histogram(cus.A1(idx_cus));
hold on;
histogram(nik.A1(idx_nik));
histogram(cus2.A1(idx_cus2));
histogram(ldf.A1(idx_ldf));
histogram(fresh.A1(idx_fresh));
legend('custom','nikon','custom2','ldf','fresh');

figure;

histogram(cus.A1(idx_cus)./cus.B1(idx_cus));
hold on;
histogram(nik.A1(idx_nik)./nik.B1(idx_nik));
histogram(cus2.A1(idx_cus2)./cus2.B1(idx_cus2));
histogram(ldf.A1(idx_ldf)./ldf.B1(idx_ldf));
legend('custom','nikon','custom2','ldf');