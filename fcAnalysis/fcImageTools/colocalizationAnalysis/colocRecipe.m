stack1 = '/Users/fchang/Dropbox/Public/smalldataset/fcDataStorage/20160107-redGr/BWY762B_w3-redGr(CyanTTL)_s2_t710.tif';
stack2 = '/Users/fchang/Dropbox/Public/smalldataset/fcDataStorage/20160107-redGr/BWY762B_w3-redGr(GreenTTL)_s2_t710.tif';

stack1 = importStack(stack1);
stack2 = importStack(stack2);

mask = genMaskWOtsu(stack1);

 genColocalizationScatter(stack1,stack2,mask)