%% process 2 photon sordaria

img = '/Users/frederickchang/Dropbox/sordaria for fred/Image1 black 101513.tif';
stack = importStack(img);
kern = ndGauss([2,2,2],[9 9 9]);

est = findSpotsStage1V2(stack,kern,ones(size(stack)));
convData = regularConv({stack},{kern});
convData = convData.regularConv{1};
plot3Dstack(catNorm(stack,est.A1,est.LLRatio,convData));
exportStack('~/Desktop/LLR_of_Sordaria',est.LLRatio);
exportStack('~/Desktop/A1_of_Sordaria',est.A1);
