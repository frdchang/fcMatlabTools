function [] = genDataSetGivenAB(A,B)
%GENDATASETGIVENAB Summary of this function goes here
%   Detailed explanation goes here

Nsamples = 100;
saveFolder = 'Desktop/genData';
rootFileName = ['data-A' num2str(A) '-B' num2str(B)];

saveFolder = [getHomeDir filesep saveFolder filesep rootFileName filesep];

for i = 1:Nsamples
    [test,truth] = genDataGivenAB(A,B);
    exportSingleFitsStack([saveFolder incrementFileName(rootFileName,i)],test);
end
theta = genThetaFromSynSpotStruct_for_single3DGauss(truth.synSpotList{1});
save([saveFolder 'theta'],'theta');

