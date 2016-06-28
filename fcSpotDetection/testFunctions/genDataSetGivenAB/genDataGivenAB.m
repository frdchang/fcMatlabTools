function [cameraNoiseData,sampleSpot] = genDataGivenAB(A,B,varargin)
%GENDATAGIVENAB Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.readNoiseData = 1.6;
params.gain          = 2.1;     % ADU/electrons
params.offset        = 100;     % ADU units
params.QE            = 0.7;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% here is a single spot with parameters {xp,yp,zp,amp}, 
spotParamStruct1.xp       = 0.45657e-6;          % (units m in specimen plane)
spotParamStruct1.yp       = 0.12246e-6;          % (units m in specimen plane)
spotParamStruct1.zp       = 0.113245e-6;         % (units m in specimen plane)
spotParamStruct1.amp      = A;                   % (number of electrons at peak)
spotList                  = {spotParamStruct1};
sampleSpot                = genSyntheticSpots(...
    'useCase',2,'bkgndVal',B,'spotList',spotList,params);

groundTruthData = sampleSpot.synAmp + sampleSpot.synBak;
cameraNoiseData = genCameraNoiseOnly(groundTruthData,params);

end

