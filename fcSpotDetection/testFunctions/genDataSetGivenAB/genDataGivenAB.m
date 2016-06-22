function [cameraNoiseData,sampleSpot] = genDataGivenAB(A,B)
%GENDATAGIVENAB Summary of this function goes here
%   Detailed explanation goes here
%% test recall rate and localization error at a given A,B value
% generate sample dataset size
sampleSpot                = genSyntheticSpots(...
    'useCase',1);
readNoiseData = repmat(lognrnd(1.6,1.1,size(sampleSpot.data(:,:,1))),[1 1 size(sampleSpot.data,3)]);
gain          = 2.1;     % ADU/electrons
offset        = 100;     % ADU units
QE            = 0.7;     

% here is a single spot with parameters {xp,yp,zp,amp}, 
spotParamStruct1.xp       = 0.45657e-6;          % (units m in specimen plane)
spotParamStruct1.yp       = 0.12246e-6;          % (units m in specimen plane)
spotParamStruct1.zp       = 0.113245e-6;         % (units m in specimen plane)
spotParamStruct1.amp      = A;                   % (number of electrons at peak)
spotList                  = {spotParamStruct1};
sampleSpot                = genSyntheticSpots(...
    'useCase',2,'bkgndVal',B,'readNoise',readNoiseData,'gain',gain,'offset',offset,'QE',QE,'spotList',spotList);

groundTruthData = sampleSpot.synAmp + sampleSpot.synBak;
cameraNoiseData = genCameraNoiseOnly(groundTruthData,'readNoise',readNoiseData,'gain',gain,'offset',offset,'QE',QE);

end

