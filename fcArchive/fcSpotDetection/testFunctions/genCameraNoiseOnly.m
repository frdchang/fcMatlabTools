function [sampledData,cameraParams,sampledCameraNoise] = genCameraNoiseOnly(trueData,varargin)
%GENCAMERANOISEONLY will take trueData as the poisson level, then add gaussian read noise to simulate a with a scmos or ccd camera.
%
%   note for fred: in the future if the user provides a string file link
%   for a parameter, load that dataset in for that parameter, this will
%   allow for real calibrated microscope parameters.
%
%   note for fred: parameters are just placeholders, go make sure they are
%   correct in the future.

%--parameters--------------------------------------------------------------
params.readNoiseData     = 1.6;     % electrons^2 (sigma)
params.gain          = 2.1;     % ADU/electrons
params.offset        = 100;     % ADU units
params.QE            = 0.7;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% lambda photons to lambda electrons captured
sampledData = double(trueData)*params.QE;
% quantum noise
% sampledData = poissrnd(sampledData);
% poissonNoiseOnly = sampledData;
% read noise
% if read noise value is infinity just put large number
params.readNoiseData(params.readNoiseData==inf) = 10000;
if isscalar(params.readNoiseData);
    sampledCameraNoise = normrnd(0,sqrt(params.readNoiseData),size(trueData));
    sampledData = sampledData + sampledCameraNoise;
else
    sampledCameraNoise = normrnd(0,sqrt(params.readNoiseData));
    sampledData = sampledData + sampledCameraNoise;
end
% convert from electrons to ADU
sampledData = sampledData.*params.gain + params.offset;
cameraParams.readNoiseData = params.readNoiseData;
cameraParams.gain          = params.gain;
cameraParams.offset        = params.offset;
cameraParams.QE            = params.QE;


