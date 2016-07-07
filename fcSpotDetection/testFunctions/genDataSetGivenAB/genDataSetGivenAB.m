function [] = genDataSetGivenAB(A,B,varargin)
%GENDATASETGIVENAB Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.Nsamples = 100;
params.saveFolder = 'Desktop/matlabGenerated/fcData/genData';
params.rootFileName = ['data-A' num2str(A) '-B' num2str(B)];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

saveFolder = [getHomeDir filesep params.saveFolder filesep params.rootFileName filesep];
for i = 1:params.Nsamples
    [test,truth] = genDataGivenAB(A,B,params);
    exportSingleFitsStack([saveFolder incrementFileName(params.rootFileName,i)],test);
end

theta = genThetaFromSynSpotStruct_for_single3DGauss(truth.synSpotList{1});
save([saveFolder 'theta-' params.rootFileName],'theta');

