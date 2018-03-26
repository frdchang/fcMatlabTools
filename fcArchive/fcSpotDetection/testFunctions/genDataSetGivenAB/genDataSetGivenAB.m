function [] = genDataSetGivenAB(A,B,varargin)
%GENDATASETGIVENAB Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.Nsamples = 100;
params.saveFolder = 'Desktop/matlabGenerated/fcData/genData';
params.rootFileName = ['data-A' num2str(A) '-B' array2str(B)];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

saveFolder = [getHomeDir filesep params.saveFolder filesep params.rootFileName filesep];
for i = 1:params.Nsamples
    [test,truth] = genDataGivenAB(A,B,params);
    exportSingleFitsStack([saveFolder incrementFileName(params.rootFileName,i)],test);
end

theta = {};
for i = 1:numel(truth)
   theta{end+1} = truth{i}.synSpotList{1}; 
end
for i = 1:numel(theta)
theta{i} = genThetaFromSynSpotStruct_for_single3DGauss(theta{i});
end
for i = 2:numel(theta)
theta{i}{2} = theta{i}{2} + size(test,2)/numel(truth)*(i-1); 
end
save([saveFolder 'theta-' params.rootFileName],'theta');

